import { useState, useEffect } from "react";

import type { Status } from "../types";

const DB_NAME = "noteflow-fs";
const STORE = "handles";
const HANDLE_KEY = "root-dir";

async function getOrCreateSubdir(
  root: FileSystemDirectoryHandle,
  name: string,
) {
  return root.getDirectoryHandle(name, { create: true });
}

async function writeFile(
  dir: FileSystemDirectoryHandle,
  filename: string,
  content: string,
) {
  const fileHandle = await dir.getFileHandle(filename, { create: true });
  const writable = await fileHandle.createWritable();
  await writable.write(content);
  await writable.close();
}

async function readFile(
  dir: FileSystemDirectoryHandle,
  filename: string,
): Promise<string | null> {
  try {
    const fileHandle = await dir.getFileHandle(filename);
    const file = await fileHandle.getFile();
    return file.text();
  } catch {
    return null;
  }
}

async function deleteFile(dir: FileSystemDirectoryHandle, filename: string) {
  try {
    await dir.removeEntry(filename);
  } catch {
    /* ignora se non esiste */
  }
}

async function listFiles(dir: FileSystemDirectoryHandle): Promise<string[]> {
  const files: string[] = [];
  for await (const [name] of dir.entries()) {
    if (!name.startsWith(".")) files.push(name);
  }
  return files;
}

function openDB(): Promise<IDBDatabase> {
  return new Promise((resolve, reject) => {
    const req = indexedDB.open(DB_NAME, 1);
    req.onupgradeneeded = (e) => {
      (e.target as IDBOpenDBRequest).result.createObjectStore(STORE);
    };
    req.onsuccess = (e) => resolve((e.target as IDBOpenDBRequest).result);
    req.onerror = (e) => reject((e.target as IDBOpenDBRequest).error);
  });
}

async function saveHandle(handle: FileSystemDirectoryHandle) {
  const db = await openDB();
  return new Promise((resolve, reject) => {
    const tx = db.transaction(STORE, "readwrite");
    tx.objectStore(STORE).put(handle, HANDLE_KEY);
    tx.oncomplete = resolve;
    tx.onerror = (e) => reject((e.target as IDBRequest).error);
  });
}

async function loadHandle(): Promise<FileSystemDirectoryHandle | null> {
  const db = await openDB();
  return new Promise((resolve, reject) => {
    const tx = db.transaction(STORE, "readonly");
    const req = tx.objectStore(STORE).get(HANDLE_KEY);
    req.onsuccess = () => resolve(req.result || null);
    req.onerror = (e) => reject((e.target as IDBRequest).error);
  });
}

export function useFileSystem() {
  const [status, setStatus] = useState<Status>("loading");
  const [rootHandle, setRootHandle] =
    useState<FileSystemDirectoryHandle | null>(null);

  useEffect(() => {
    if (!("showDirectoryPicker" in window)) {
      setStatus("unsupported");
      return;
    }

    loadHandle()
      .then(async (handle) => {
        if (!handle) {
          setStatus("no-permission");
          return;
        }

        const perm = await handle.queryPermission({ mode: "readwrite" });
        if (perm === "granted") {
          setRootHandle(handle);
          setStatus("ready");
        } else {
          setStatus("no-permission");
        }
      })
      .catch(() => setStatus("no-permission"));
  }, []);

  async function requestAccess() {
    try {
      const handle = await window.showDirectoryPicker({ mode: "readwrite" });
      await saveHandle(handle);
      setRootHandle(handle);
      setStatus("ready");
    } catch (e: unknown) {
      if (e instanceof Error && e.name !== "AbortError") {
        console.error(e);
      }
    }
  }

  async function reauthorize() {
    const handle = await loadHandle();
    if (!handle) return;
    const perm = await handle.requestPermission({ mode: "readwrite" });
    if (perm === "granted") {
      setRootHandle(handle);
      setStatus("ready");
    }
  }

  async function saveEntity<T extends { id: string }>(
    type: string,
    entity: T,
  ): Promise<T> {
    if (!rootHandle) throw new Error("Nessun accesso alla cartella");
    const dir = await getOrCreateSubdir(rootHandle, type);
    await writeFile(dir, `${entity.id}.json`, JSON.stringify(entity, null, 2));
    return entity;
  }

  async function loadEntities<T>(type: string): Promise<T[]> {
    if (!rootHandle) return [];
    const dir = await getOrCreateSubdir(rootHandle, type);
    const files = await listFiles(dir);
    const entities: T[] = [];
    for (const file of files) {
      if (!file.endsWith(".json")) continue;
      const raw = await readFile(dir, file);
      if (raw) {
        try {
          entities.push(JSON.parse(raw));
        } catch {
          /* salta file corrotti */
        }
      }
    }
    return entities.sort((a: any, b: any) => b.updatedAt - a.updatedAt);
  }

  async function deleteEntity(type: string, id: string) {
    if (!rootHandle) return;
    const dir = await getOrCreateSubdir(rootHandle, type);
    await deleteFile(dir, `${id}.json`);
  }

  return {
    status,
    rootHandle,
    requestAccess,
    reauthorize,
    saveEntity,
    loadEntities,
    deleteEntity,
  };
}

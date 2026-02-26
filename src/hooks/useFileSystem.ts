import { useState, useEffect } from "react";

type Status = "loading" | "ready" | "no-permission" | "unsupported";

const DB_NAME = "noteflow-fs";
const STORE = "handles";
const HANDLE_KEY = "root-dir";

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

  return { status, rootHandle, requestAccess, reauthorize };
}

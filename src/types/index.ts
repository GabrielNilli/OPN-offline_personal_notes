export type Note = {
  id: string;
  title: string;
  content: string;
  createdAt: number;
  updatedAt: number;
};

export type ListItem = {
  id: string;
  text: string;
  done: boolean;
  createdAt: number;
};

export type List = {
  id: string;
  title: string;
  items: ListItem[];
  createdAt: number;
  updatedAt: number;
};

export type Chart = {
  id: string;
  title: string;
  type: "line" | "bar" | "pie";
  series: ChartSeries[];
  data: ChartDataRow[];
  createdAt: number;
  updatedAt: number;
};

export type ChartSeries = {
  name: string;
  color: string;
};

export type ChartDataRow = {
  label: string;
  [key: string]: string | number;
};

export type FileSystemHook = {
  status: "loading" | "ready" | "no-permission" | "unsupported";
  rootHandle: FileSystemDirectoryHandle | null;
  requestAccess: () => Promise<void>;
  reauthorize: () => Promise<void>;
  saveEntity: <T extends { id: string }>(type: string, entity: T) => Promise<T>;
  loadEntities: <T>(type: string) => Promise<T[]>;
  deleteEntity: (type: string, id: string) => Promise<void>;
};

export type Status = "loading" | "ready" | "no-permission" | "unsupported";

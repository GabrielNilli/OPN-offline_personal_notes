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

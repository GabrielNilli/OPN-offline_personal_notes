import type { FileSystemHook } from "../../types";

type Props = {
  fs: FileSystemHook;
};

export default function ChartsView({ fs }: Props) {
  return <p>Grafici</p>;
}

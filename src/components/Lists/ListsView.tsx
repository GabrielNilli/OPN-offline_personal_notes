import type { FileSystemHook } from "../../types";

type Props = {
  fs: FileSystemHook;
};

export default function ListsView({ fs }: Props) {
  return <p>Liste view</p>;
}

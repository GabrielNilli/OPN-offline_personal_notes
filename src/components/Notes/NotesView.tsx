import type { FileSystemHook } from "../../types";

type Props = {
  fs: FileSystemHook;
};

export default function NotesView({ fs }: Props) {
  return <p>Note</p>;
}

import type { FileSystemHook } from "../../types";

type Props = {
  fs: FileSystemHook;
};

export default function HomeView({ fs }: Props) {
  return <p>Home</p>;
}

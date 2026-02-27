import type { FileSystemHook } from "../../types";

type Props = {
  fs: FileSystemHook;
};

export default function SettingsView({ fs }: Props) {
  return <p>Settings</p>;
}

type Props = {
  onRequest: () => void;
  onReauth: () => void;
};

export default function SetupScreen({ onRequest, onReauth }: Props) {
  return (
    <div>
      <h1>NoteFlow</h1>
      <p>Scegli una cartella dove salvare i tuoi dati</p>
      <button onClick={onRequest}>Scegli cartella</button>
      <button onClick={onReauth}>Ri-autorizza cartella esistente</button>
    </div>
  );
}

import { useState } from "react";
import { useFileSystem } from "./hooks/useFileSystem";
import SetupScreen from "./components/SetupScreen";
import NotesView from "./components/Notes/NotesView";
import ChartsView from "./components/Chart/ChartsView";
import HomeView from "./components/Home/HomeView";
import SettingsView from "./components/Settings/SettingsView";

type Tab = "home" | "notes" | "charts" | "settings";

export default function App() {
  const fs = useFileSystem();
  const [tab, setTab] = useState<Tab>("notes");
  const [showAdd, setShowAdd] = useState(false);

  if (fs.status === "loading") return <p>Caricamento...</p>;
  if (fs.status === "unsupported") return <p>Browser non supportato.</p>;
  if (fs.status !== "ready")
    return (
      <SetupScreen onRequest={fs.requestAccess} onReauth={fs.reauthorize} />
    );

  return (
    <div
      style={{ display: "flex", flexDirection: "column", minHeight: "100dvh" }}
    >
      {/* Contenuto principale */}
      <main style={{ flex: 1, overflowY: "auto" }}>
        {tab === "home" && <HomeView fs={fs} />}
        {tab === "notes" && <NotesView fs={fs} />}
        {tab === "charts" && <ChartsView fs={fs} />}
        {tab === "settings" && <SettingsView fs={fs} />}
      </main>

      {showAdd && (
        <div
          style={{
            position: "fixed",
            inset: 0,
            background: "rgba(0,0,0,0.6)",
            display: "flex",
            alignItems: "flex-end",
            zIndex: 200,
          }}
          onClick={() => setShowAdd(false)}
        >
          <div
            style={{
              background: "#1a1a2e",
              width: "100%",
              padding: 24,
              borderRadius: "20px 20px 0 0",
              display: "flex",
              flexDirection: "column",
              gap: 12,
            }}
            onClick={(e) => e.stopPropagation()}
          >
            {tab === "home" && (
              <>
                <button>📝 Nuova Nota</button>
                <button>✅ Nuova Lista</button>
                <button>📊 Nuovo Grafico</button>
              </>
            )}

            {tab === "notes" && (
              <>
                <button>📝 Nuova Nota</button>
                <button>✅ Nuova Lista</button>
              </>
            )}

            {tab === "charts" && (
              <>
                <button>📊 Grafico a Barre</button>
                <button>🥧 Grafico a Torta</button>
                <button>📈 Grafico a Linee</button>
              </>
            )}

            {tab === "settings" && null}
          </div>
        </div>
      )}

      {/* Bottom navigation */}
      <nav
        style={{
          position: "fixed",
          bottom: 0,
          left: 0,
          right: 0,
          display: "flex",
          alignItems: "center",
          justifyContent: "space-around",
          background: "#1a1a2e",
          borderTop: "1px solid #333",
          height: "64px",
          zIndex: 100,
        }}
      >
        <button onClick={() => setTab("home")}>🏠</button>
        <button onClick={() => setTab("notes")}>📝</button>
        <button
          onClick={() => setShowAdd(true)}
          style={{
            width: 52,
            height: 52,
            borderRadius: "50%",
            background: "#6366f1",
            border: "none",
            fontSize: "1.5rem",
            cursor: "pointer",
          }}
        >
          ➕
        </button>
        <button onClick={() => setTab("charts")}>📊</button>
        <button onClick={() => setTab("settings")}>⚙️</button>
      </nav>
    </div>
  );
}

import * as React from "react";
import {
  mount,
  ShinyModuleProvider,
  ShinyOutput,
  useShinyBusy,
  useShinyInitialized,
} from "./shinyreact";
import { TitleInput } from "./components/TitleInput";
import { Download } from "./components/Download";
import { ListTab } from "./components/ListTab";
import { SummaryTab } from "./components/SummaryTab";
import { GraphsTab } from "./components/GraphsTab";
import "./ui.css";

// Each ShinyModuleProvider namespace matches the module id in app_server().
const TABS = [
  { id: "summary", label: "Summary", ns: "summary", body: <SummaryTab /> },
  { id: "graphs", label: "Graphs", ns: "viz", body: <GraphsTab /> },
  { id: "list", label: "List", ns: "listviewerlite", body: <ListTab /> },
];

function App() {
  const initialized = useShinyInitialized();
  const busy = useShinyBusy();
  const [tab, setTab] = React.useState("summary");

  if (!initialized) return null;

  return (
    <div className="ttd-page">
      <header className="ttd-header">
        <h4 className="m-0 fw-bold">#TidyTuesday Viewer</h4>
        {busy && <span className="spinner-border spinner-border-sm" role="status" aria-label="Loading" />}
      </header>
      <div className="ttd-layout">
        <aside className="ttd-sidebar">
          <ShinyModuleProvider namespace="input">
            <TitleInput />
          </ShinyModuleProvider>
          <ShinyModuleProvider namespace="download">
            <Download />
          </ShinyModuleProvider>
          <details>
            <summary>
              <strong>
                <code>app_server()</code> reactive values:
              </strong>
            </summary>
            <ShinyOutput id="dev" className="shiny-html-output" />
          </details>
        </aside>
        <main className="ttd-main">
          <ul className="nav nav-tabs mb-3" role="tablist">
            {TABS.map((t) => (
              <li className="nav-item" key={t.id} role="presentation">
                <button
                  type="button"
                  role="tab"
                  aria-selected={tab === t.id}
                  className={`nav-link${tab === t.id ? " active" : ""}`}
                  onClick={() => setTab(t.id)}
                >
                  {t.label}
                </button>
              </li>
            ))}
          </ul>
          {/* Every tab stays mounted; hidden tabs are display: none, so Shiny
              suspends their outputs the same way bslib tabs did. */}
          {TABS.map((t) => (
            <section key={t.id} role="tabpanel" hidden={tab !== t.id}>
              <ShinyModuleProvider namespace={t.ns}>{t.body}</ShinyModuleProvider>
            </section>
          ))}
        </main>
      </div>
    </div>
  );
}

mount(<App />);

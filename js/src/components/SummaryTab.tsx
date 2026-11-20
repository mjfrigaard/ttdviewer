import * as React from "react";
import { asArray, ShinyOutput, useShinyOutputValue } from "../shinyreact";
import { DatasetSelect } from "./DatasetSelect";

type FileInfo = { name: string; rows: number; cols: number };
type Overview = { dates: string | string[]; files: FileInfo | FileInfo[] } | null;

const WIDGET = "reactable html-widget html-widget-output";

// Server: mod_summary_server().
export function SummaryTab() {
  const overview = useShinyOutputValue<Overview>("overview", null);
  const files = asArray(overview?.files);
  const dates = asArray(overview?.dates);

  return (
    <div className="card">
      <div className="card-body">
        {overview && (
          <div id="summary-overview">
            {dates.length > 0 && <p>TidyTuesday date: {dates.join(", ")}</p>}
            <p>
              <strong>
                {files.length} {files.length === 1 ? "file" : "files"}
              </strong>
            </p>
            <ul>
              {files.map((f, i) => (
                <li key={i}>
                  <code>{f.name}</code>: {f.rows.toLocaleString("en-US")} rows x {f.cols} columns
                </li>
              ))}
            </ul>
          </div>
        )}
        <DatasetSelect inputId="ds_input" outputId="choices" label="Dataset" />
        <h5>Summary statistics</h5>
        <ShinyOutput id="stats" className={WIDGET} />
        <h5 className="mt-3">Variable information</h5>
        <ShinyOutput id="vars" className={WIDGET} />
        <h5 className="mt-3">Data</h5>
        <p className="text-muted small">
          Shows the first 1,000 rows. Download the data for the full file.
        </p>
        <ShinyOutput id="table" className={WIDGET} />
      </div>
    </div>
  );
}

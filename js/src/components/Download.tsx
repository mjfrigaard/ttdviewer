import * as React from "react";
import { ShinyOutput, useShinyInput } from "../shinyreact";

const FORMATS = [
  { value: "csv", label: "CSV" },
  { value: "parquet", label: "Parquet" },
  { value: "original", label: "Original format" },
];

// Server: mod_download_server(). Sends input$format; output$download is a
// downloadHandler(), which binds to an <a class="shiny-download-link">.
export function Download() {
  const [format, setFormat] = useShinyInput("format", "csv");

  return (
    <div className="mb-3">
      <label className="form-label fw-bold" htmlFor="dl-format">
        Download Data:
      </label>
      <select
        id="dl-format"
        className="form-select mb-2"
        value={format}
        onChange={(e) => setFormat(e.target.value)}
      >
        {FORMATS.map((f) => (
          <option key={f.value} value={f.value}>
            {f.label}
          </option>
        ))}
      </select>
      <ShinyOutput
        id="download"
        tagName="a"
        className="btn btn-primary w-100 shiny-download-link"
        href=""
        target="_blank"
        download=""
      >
        Download Data
      </ShinyOutput>
      <p className="text-muted small mt-2">Several files download as one .zip.</p>
    </div>
  );
}

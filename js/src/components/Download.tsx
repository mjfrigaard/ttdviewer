import * as React from "react";
import { ShinyOutput, asArray, useShinyInput, useShinyOutputValue } from "../shinyreact";

const FORMATS = [
  { value: "csv", label: "CSV" },
  { value: "parquet", label: "Parquet" },
];

// Server: mod_download_server(). Sends input$file ("all" or one file name)
// and input$format; output$files holds the file names; output$download is a
// downloadHandler(), which binds to an <a class="shiny-download-link">.
export function Download() {
  const files = asArray(useShinyOutputValue<string | string[] | null>("files", null));
  const [file, setFile] = useShinyInput("file", "all");
  const [format, setFormat] = useShinyInput("format", "csv");
  const key = files.join("\u0000");

  // a new title resets the choice to all files
  React.useEffect(() => {
    setFile("all");
  }, [key]);

  return (
    <div className="mb-3">
      <label className="form-label fw-bold" htmlFor="dl-file">
        Download Data:
      </label>
      <select
        id="dl-file"
        className="form-select mb-2"
        value={file}
        disabled={files.length === 0}
        onChange={(e) => setFile(e.target.value)}
      >
        <option value="all">All files</option>
        {files.map((f, i) => (
          <option key={i} value={f}>
            {f}
          </option>
        ))}
      </select>
      <label className="form-label" htmlFor="dl-format">
        Format:
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
      <p className="text-muted small mt-2">All files from a title with several files download as one .zip.</p>
    </div>
  );
}

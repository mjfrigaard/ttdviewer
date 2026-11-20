import * as React from "react";
import { asArray, useShinyInput, useShinyOutputValue } from "../shinyreact";

// Server: mod_input_server(). Sends input$ds_title; reads output$titles.
export function TitleInput() {
  const titles = asArray(useShinyOutputValue<string | string[]>("titles", []));
  const [title, setTitle] = useShinyInput("ds_title", "Space Launches");

  return (
    <div className="mb-3">
      <label className="form-label fw-bold" htmlFor="ds-title">
        Choose Dataset Title:
      </label>
      <select
        id="ds-title"
        className="form-select"
        value={title}
        onChange={(e) => setTitle(e.target.value)}
      >
        {titles.map((t) => (
          <option key={t} value={t}>
            {t}
          </option>
        ))}
      </select>
    </div>
  );
}

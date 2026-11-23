import * as React from "react";
import { ImageOutput, useShinyInput } from "../shinyreact";
import { DatasetSelect } from "./DatasetSelect";

// Must match PLOT_TYPES in R/mod_plot.R.
const PLOT_TYPES = [
  { value: "types", label: "Column types" },
  { value: "mem", label: "Memory usage" },
  { value: "na", label: "Missing values" },
  { value: "cor", label: "Correlations" },
  { value: "imb", label: "Most common values" },
  { value: "num", label: "Numeric distributions" },
  { value: "cat", label: "Categorical levels" },
];

// Server: mod_plot_server(). One renderPlot() per type: output$plt_<type>.
export function GraphsTab() {
  const [plots, setPlots] = useShinyInput<string[]>("plots", ["types", "mem", "na"]);

  const toggle = (value: string) =>
    setPlots(plots.includes(value) ? plots.filter((p) => p !== value) : [...plots, value]);

  return (
    <div className="card">
      <div className="card-body">
        <DatasetSelect inputId="dataset" outputId="datasets" label="Choose dataset:" />
        <fieldset className="mb-3">
          <legend className="form-label fs-6">Select plot type:</legend>
          {PLOT_TYPES.map((p) => (
            <div className="form-check form-check-inline" key={p.value}>
              <input
                className="form-check-input"
                type="checkbox"
                id={`plot-${p.value}`}
                checked={plots.includes(p.value)}
                onChange={() => toggle(p.value)}
              />
              <label className="form-check-label" htmlFor={`plot-${p.value}`}>
                {p.label}
              </label>
            </div>
          ))}
        </fieldset>
        {PLOT_TYPES.filter((p) => plots.includes(p.value)).map((p) => (
          <div key={p.value}>
            <h4>{p.label}</h4>
            <ImageOutput id={`plt_${p.value}`} width="100%" height="300px" />
          </div>
        ))}
      </div>
    </div>
  );
}

import * as React from "react";
import { asArray, useShinyInput, useShinyOutputValue } from "../shinyreact";

// A select fed by a reactive_output() of file names. When the file names
// change (a new title), it selects the first one, like updateSelectInput() did.
export function DatasetSelect(props: { inputId: string; outputId: string; label: string }) {
  const choices = asArray(useShinyOutputValue<string | string[] | null>(props.outputId, null));
  const [value, setValue] = useShinyInput<string | null>(props.inputId, null);
  const key = choices.join("\u0000");

  React.useEffect(() => {
    if (choices.length > 0 && (value === null || !choices.includes(value))) {
      setValue(choices[0]);
    }
  }, [key]);

  return (
    <div className="mb-3">
      <label className="form-label" htmlFor={props.inputId}>
        {props.label}
      </label>
      <select
        id={props.inputId}
        className="form-select"
        value={value ?? ""}
        disabled={choices.length === 0}
        onChange={(e) => setValue(e.target.value)}
      >
        {choices.map((c, i) => (
          <option key={i} value={c}>
            {c}
          </option>
        ))}
      </select>
    </div>
  );
}

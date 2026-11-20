import * as React from "react";
import { ShinyOutput } from "../shinyreact";

// Server: mod_list_server(). output$list is a renderUI() of listviewerlite::listview().
export function ListTab() {
  return (
    <div className="card">
      <div className="card-body">
        <p>
          Below is a preview of the{" "}
          <a href="https://github.com/rfordatascience/tidytuesday">#TidyTuesday</a>{" "}
          dataset(s) provided by{" "}
          <a href="https://long39ng.github.io/listviewerlite/">
            <code>listviewerlite</code>
          </a>
          .
        </p>
        <ShinyOutput id="list" className="shiny-html-output" />
      </div>
    </div>
  );
}

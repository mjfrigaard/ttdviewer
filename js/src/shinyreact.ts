// Typed access to the hooks and components that shinyreact.js installs on
// window.shinyreact. Only what ttdviewer uses is declared.
import type * as React from "react";

type InputOpts = { debounceMs?: number; priority?: "event"; type?: string };
type OutputStatus = "pending" | "ready" | "recalculating" | "error";

interface ShinyReact {
  useShinyInput<T>(id: string, defaultValue: T, opts?: InputOpts): [T, (value: T) => void];
  useShinyOutputValue<T>(id: string, defaultValue?: T): T;
  useShinyOutputStatus(id: string): OutputStatus;
  useShinyInitialized(): boolean;
  useShinyBusy(): boolean;
  ShinyOutput: React.FC<{ id: string; tagName?: string; className?: string; children?: React.ReactNode; [attr: string]: unknown }>;
  ImageOutput: React.FC<{ id: string; className?: string; width?: string; height?: string }>;
  ShinyModuleProvider: React.FC<{ namespace: string; children?: React.ReactNode }>;
  ReactDOM: { createRoot(el: Element): { render(node: React.ReactNode): void } };
}

declare global {
  interface Window {
    shinyreact: ShinyReact;
  }
}

export const {
  useShinyInput,
  useShinyOutputValue,
  useShinyOutputStatus,
  useShinyInitialized,
  useShinyBusy,
  ShinyOutput,
  ImageOutput,
  ShinyModuleProvider,
} = window.shinyreact;

// reactive_output() sends a length one vector as a scalar; always get an array.
export function asArray<T>(x: T | T[] | null | undefined): T[] {
  if (x === null || x === undefined) return [];
  return Array.isArray(x) ? x : [x];
}

// page_react() emits no mount node, so append one to <body>.
export function mount(node: React.ReactNode) {
  const el = document.body.appendChild(document.createElement("div"));
  window.shinyreact.ReactDOM.createRoot(el).render(node);
}

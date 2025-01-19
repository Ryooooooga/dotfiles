import { ToEvent, toKey } from "./deps.ts";

const keyAliases: Partial<Record<string, ToEvent>> = {
  "-": toKey("-"),
  _: toKey("-", "shift"),
  "=": toKey("="),
  "+": toKey("=", "shift"),
  ">": toKey(".", "shift"),
  "/": toKey("/"),
  "?": toKey("/", "shift"),
  "!": toKey("1", "shift"),
  "@": toKey("2", "shift"),
  "#": toKey("3", "shift"),
  $: toKey("4", "shift"),
  "%": toKey("5", "shift"),
  "^": toKey("6", "shift"),
  "&": toKey("7", "shift"),
  "*": toKey("8", "shift"),
  "(": toKey("9", "shift"),
  ")": toKey("0", "shift"),
  "{": toKey("[", "shift"),
  "}": toKey("]", "shift"),
  '"': toKey("'", "shift"),
  "`": toKey("`"),
  "~": toKey("`", "shift"),
} as const;

export function toStroke(text: string): ToEvent[] {
  return [...text].map(
    (c): ToEvent =>
      keyAliases[c] ?? throw_(new Error(`unknown character '${c}'`)),
  );
}

function throw_(error: Error): never {
  throw error;
}

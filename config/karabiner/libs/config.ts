import { DeviceIdentifier, KarabinerProfile } from "./deps.ts";
import { SimpleModifications } from "./simple_modifications.ts";

export interface KarabinerConfigExt /* extends KarabinerConfig */ {
  profiles: KarabinerProfileExt[];
}

export interface KarabinerProfileExt extends KarabinerProfile {
  devices: KarabinerDevice[];
  fn_function_keys?: SimpleModifications;
  simple_modifications?: SimpleModifications;
  virtual_hid_keyboard: Record<string, unknown>;
}

export interface KarabinerDevice {
  identifiers: DeviceIdentifier;
  simple_modifications?: SimpleModifications;
  ignore?: boolean;
}

export async function saveConfig(path: URL, config: KarabinerConfigExt) {
  await Deno.writeTextFile(path, toJSON(config));
}

export function defaultProfile(
  profile: Omit<
    KarabinerProfileExt,
    "name" | "selected" | "virtual_hid_keyboard"
  >,
): KarabinerProfileExt {
  return {
    ...profile,
    name: "Default profile",
    selected: true,
    virtual_hid_keyboard: {
      country_code: 0,
      keyboard_type_v2: "ansi",
    },
  };
}

function toJSON(value: unknown): string {
  const indentWidth = 2;
  return JSON.stringify(
    value,
    (_key, value) => isObject(value) ? sortObjectKeys(value) : value,
    indentWidth,
  );
}

function isObject(value: unknown): value is Record<string, unknown> {
  return typeof value === "object" && value !== null && !Array.isArray(value);
}

function sortObjectKeys(obj: Record<string, unknown>): Record<string, unknown> {
  return Object.fromEntries(
    Object.entries(obj).sort(([ak], [bk]) => ak.localeCompare(bk)),
  );
}

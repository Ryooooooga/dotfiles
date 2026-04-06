import {
  DeviceIdentifier,
  KarabinerConfig,
  KarabinerProfile,
  SimpleManipulator,
} from "karabinerts/deno.ts";
import { writeContext } from "karabinerts/output.ts";

export interface KarabinerProfileExt extends KarabinerProfile {
  devices: KarabinerDevice[];
  fn_function_keys?: SimpleManipulator[];
  virtual_hid_keyboard: Record<string, unknown>;
}

export interface KarabinerDevice {
  identifiers: DeviceIdentifier;
  simple_modifications?: SimpleManipulator[];
  ignore?: boolean;
}

export async function saveConfig(config: KarabinerConfig) {
  await writeContext.writeKarabinerConfig(toJSON(config));
}

export function defaultProfile(
  profile: Omit<
    KarabinerProfileExt,
    "name" | "selected" | "virtual_hid_keyboard"
  >,
): KarabinerProfileExt {
  return {
    ...profile,
    complex_modifications: {
      ...profile.complex_modifications,
      parameters: {
        "basic.to_if_alone_timeout_milliseconds": 250,
        "basic.to_if_held_down_threshold_milliseconds": 250,
      },
    },
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
    (_key, value) => (isObject(value) ? sortObjectKeys(value) : value),
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

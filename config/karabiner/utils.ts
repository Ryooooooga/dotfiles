export * from "https://deno.land/x/karabinerts/deno.ts";

import {
  DeviceIdentifier,
  FromEvent,
  KarabinerConfig,
  KarabinerProfile,
  ToEvent,
} from "https://deno.land/x/karabinerts/deno.ts";
import { BasicManipulatorBuilder } from "https://deno.land/x/karabinerts/config/manipulator.ts";

export interface SimpleManipulator {
  from: FromEvent;
  to?: ToEvent[];
}

export type SimpleModifications = SimpleManipulator[];

export type KarabinerGlobal = Record<string, unknown>;

export interface KarabinerDevice {
  disable_built_in_keyboard_if_exists: boolean;
  fn_function_keys: SimpleModifications;
  identifiers: DeviceIdentifier;
  ignore: boolean;
  manipulate_caps_lock_led: boolean;
  simple_modifications: SimpleModifications;
  treat_as_built_in_keyboard: boolean;
}

export interface KarabinerProfileExt extends KarabinerProfile {
  devices: KarabinerDevice[];
  fn_function_keys: SimpleModifications;
  parameters: Record<string, unknown>;
  simple_modifications: SimpleModifications;
  virtual_hid_keyboard: Record<string, unknown>;
}

export interface KarabinerConfigExt extends KarabinerConfig {
  global: KarabinerGlobal;
  profiles: [KarabinerProfileExt];
}

export const defaultGlobals: KarabinerGlobal = {
  ask_for_confirmation_before_quitting: true,
  check_for_updates_on_startup: true,
  show_in_menu_bar: true,
  show_profile_name_in_menu_bar: false,
  unsafe_ui: false,
};

export const defaultFnFunctionKeys: SimpleModifications = [
  {
    from: { key_code: "f1" },
    to: [{ consumer_key_code: "display_brightness_decrement" }],
  },
  {
    from: { key_code: "f2" },
    to: [{ consumer_key_code: "display_brightness_increment" }],
  },
  {
    from: { key_code: "f3" },
    to: [{ key_code: "mission_control" }],
  },
  {
    from: { key_code: "f4" },
    to: [{ key_code: "launchpad" }],
  },
  {
    from: { key_code: "f5" },
    to: [{ key_code: "illumination_decrement" }],
  },
  {
    from: { key_code: "f6" },
    to: [{ key_code: "illumination_increment" }],
  },
  {
    from: { key_code: "f7" },
    to: [{ consumer_key_code: "rewind" }],
  },
  {
    from: { key_code: "f8" },
    to: [{ consumer_key_code: "play_or_pause" }],
  },
  {
    from: { key_code: "f9" },
    to: [{ consumer_key_code: "fastforward" }],
  },
  {
    from: { key_code: "f10" },
    to: [{ consumer_key_code: "mute" }],
  },
  {
    from: { key_code: "f11" },
    to: [{ consumer_key_code: "volume_decrement" }],
  },
  {
    from: { key_code: "f12" },
    to: [{ consumer_key_code: "volume_increment" }],
  },
];

export function simpleModifications(
  builders: BasicManipulatorBuilder[],
): SimpleModifications {
  return builders
    .flatMap((builder) => builder.build())
    .map((m) => ({ ...m, type: undefined }));
}

const keyAliases = {
  "-": { key_code: "hyphen" },
  _: { key_code: "hyphen", modifiers: ["shift"] },
  "=": { key_code: "equal_sign" },
  "+": { key_code: "equal_sign", modifiers: ["shift"] },
  ">": { key_code: "period", modifiers: ["shift"] },
  "/": { key_code: "slash" },
  "?": { key_code: "slash", modifiers: ["shift"] },
  "!": { key_code: "1", modifiers: ["shift"] },
  "@": { key_code: "2", modifiers: ["shift"] },
  "#": { key_code: "3", modifiers: ["shift"] },
  $: { key_code: "4", modifiers: ["shift"] },
  "%": { key_code: "5", modifiers: ["shift"] },
  "^": { key_code: "6", modifiers: ["shift"] },
  "&": { key_code: "7", modifiers: ["shift"] },
  "*": { key_code: "8", modifiers: ["shift"] },
  "(": { key_code: "9", modifiers: ["shift"] },
  ")": { key_code: "0", modifiers: ["shift"] },
  "{": { key_code: "open_bracket", modifiers: ["shift"] },
  "}": { key_code: "close_bracket", modifiers: ["shift"] },
  '"': { key_code: "quote", modifiers: ["shift"] },
} as const satisfies Record<string, ToEvent>;

type KeyAlias = keyof typeof keyAliases;

export function stroke(text: string): ToEvent[] {
  return [...text].map(
    (c): ToEvent =>
      keyAliases[c as KeyAlias] ??
        (() => {
          throw new Error(`unknown character '${c}'`);
        })(),
  );
}

export type KeyboardIdentifier = {
  product_id?: number;
  vendor_id: number;
};

export function device(
  keyboard: KeyboardIdentifier,
  settings: Pick<KarabinerDevice, "simple_modifications">,
): KarabinerDevice {
  return {
    identifiers: {
      is_keyboard: true,
      is_pointing_device: false,
      ...keyboard,
    },
    disable_built_in_keyboard_if_exists: false,
    ignore: false,
    manipulate_caps_lock_led: true,
    treat_as_built_in_keyboard: false,
    fn_function_keys: [],
    ...settings,
  };
}

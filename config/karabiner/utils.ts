export * from "https://deno.land/x/karabinerts/deno.ts";
export { BasicManipulatorBuilder } from "https://deno.land/x/karabinerts/config/manipulator.ts";

import {
  ComplexModifications,
  complexModifications as _complexModifications,
  defaultComplexModificationsParameters,
  DeviceIdentifier,
  FromEvent,
  KarabinerProfile,
  ModificationParameters,
  Rule,
  RuleBuilder,
  ToEvent,
  toKey,
} from "https://deno.land/x/karabinerts/deno.ts";
import { BasicManipulatorBuilder } from "https://deno.land/x/karabinerts/config/manipulator.ts";

export interface SimpleManipulator {
  from: FromEvent;
  to?: ToEvent[];
}

export type SimpleModifications = SimpleManipulator[];

export interface KarabinerDevice {
  identifiers: DeviceIdentifier;
  simple_modifications: SimpleModifications;
}

export interface KarabinerProfileExt extends KarabinerProfile {
  devices: KarabinerDevice[];
  fn_function_keys?: SimpleModifications;
  simple_modifications?: SimpleModifications;
  virtual_hid_keyboard: Record<string, unknown>;
}

export interface KarabinerConfigExt {
  profiles: KarabinerProfileExt[];
}

export function simpleModifications(
  builders: BasicManipulatorBuilder[],
): SimpleModifications {
  return builders
    .flatMap((builder) => builder.build())
    .map(({ type: _, ...m }) => m);
}

export function complexModifications(
  rules: Array<Rule | RuleBuilder>,
  params: ModificationParameters = {},
): ComplexModifications {
  const { parameters, ...mod } = _complexModifications(rules, params);
  return {
    ...mod,
    parameters: removeDefaultParameters(
      parameters,
      defaultComplexModificationsParameters,
    ),
  };
}

function removeDefaultParameters<T extends Record<string, unknown>>(
  parameters: T,
  defaultParameters: T,
): T {
  return Object.fromEntries(
    Object.entries(parameters).filter(
      ([key, value]) => defaultParameters[key] !== value,
    ),
  ) as T;
}

const keyAliases = {
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
      ...keyboard,
    },
    ...settings,
  };
}

export async function saveConfig(path: URL, config: KarabinerConfigExt) {
  await Deno.writeTextFile(
    path,
    JSON.stringify(
      config,
      (_key, value) => {
        if (
          typeof value === "object" &&
          value !== null &&
          !Array.isArray(value)
        ) {
          return Object.fromEntries(
            Object.entries(value).sort(([ak], [bk]) => ak.localeCompare(bk)),
          );
        }
        return value;
      },
      4,
    ),
  );
}

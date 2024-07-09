#!/usr/bin/env -S deno run --check --allow-write
import {
  complexModifications,
  defaultFnFunctionKeys,
  defaultGlobals,
  device,
  ifDevice,
  ifDeviceExists,
  ifVar,
  KarabinerConfigExt,
  KarabinerProfileExt,
  KeyboardIdentifier,
  map,
  rule,
  simpleModifications,
  stroke,
  toSetVar,
  withCondition,
} from "./utils.ts";

const DEVICES = {
  apple: {
    vendor_id: 1452,
  },
  macBook2018: {
    product_id: 634,
    vendor_id: 1452,
  },
  progresTouchRetroTiny: {
    product_id: 4,
    vendor_id: 11240,
  },
  realforceR2: {
    product_id: 328,
    vendor_id: 2131,
  },
  mint60: {
    product_id: 0,
    vendor_id: 65261,
  },
} as const satisfies Record<string, KeyboardIdentifier>;

const LAYER = {
  lower: "layer-lower",
} as const;

const backspaceRule = rule(
  "Exchange Command+Backspace/Delete and Option+Backspace/Delete",
)
  .manipulators([
    map("⌫", "command", "shift").to("⌫", "option"),
    map("⌫", "option", "shift").to("⌫", "command"),
    map("⌦", "command", "shift").to("⌦", "option"),
    map("⌦", "option", "shift").to("⌦", "command"),
  ])
  .build();

const arrowKeys = [
  ["←", "j"],
  ["↓", "k"],
  ["↑", "i"],
  ["→", "l"],
] as const;

const arrowRule = rule("Exchange command + arrow keys with option + arrow keys")
  .manipulators(
    arrowKeys.flatMap(([key]) => [
      map(key, ["command", "option"], "any").to(key, ["command", "option"]),
      map(key, "command", "any").to(key, "option"),
      map(key, "option", "any").to(key, "command"),
    ]),
  );

const capsRule = rule("Change Caps Lock")
  .manipulators([
    map("caps_lock", "shift").to(stroke("->")),
    map("caps_lock", "command").to(stroke("=>")),
    map("caps_lock").condition(ifVar(LAYER.lower)).to(stroke("-")),
    map("caps_lock").to(stroke("_")),
  ]);

const lowerRule = rule("Lower Layer")
  .manipulators([
    withCondition(ifVar(LAYER.lower))([
      map("1").to(stroke("!")),
      map("2").to(stroke("@")),
      map("3").to(stroke("#")),
      map("4").to(stroke("$")),
      map("5").to(stroke("%")),

      map("6").to(stroke("^")),
      map("7").to(stroke("&")),
      map("8").to(stroke("*")),
      map("9").to(stroke("(")),
      map("0").to(stroke(")")),
      map("-").to(stroke("_")),
      map("=").to(stroke("+")),

      map("q").to(stroke("!")),
      map("w").to(stroke("@")),
      map("e").to(stroke("#")),
      map("r").to(stroke("$")),
      map("t").to(stroke("%")),

      map("a").to(stroke("^")),
      map("s").to(stroke("&")),
      map("d").to(stroke("*")),
      map("f").to(stroke("=")),
      map("g").to(stroke("+")),

      // ijkl
      ...arrowKeys.flatMap(([key, from]) => [
        map(from, ["command", "option"], "any").to(key, ["command", "option"]),
        map(from, "command", "any").to(key, "option"),
        map(from, "option", "any").to(key, "command"),
        map(from, null, "any").to(key),
      ]),
      map("u", null, "any").to("home"),
      map("o", null, "any").to("end"),
      map("p", null, "any").to("page_up"),
      map(";", null, "any").to("page_down"),

      map("z").to(stroke("(")),
      map("x").to(stroke(")")),
      map("c").to(stroke("/")),
      map("v").to(stroke("?")),

      map("[").to(stroke("{")),
      map("]").to(stroke("}")),
    ]),
    map("right_option", null, "any")
      .to(toSetVar(LAYER.lower, 1))
      .toAfterKeyUp(toSetVar(LAYER.lower, 0))
      .toIfAlone("escape"),
  ]);

const macRule = rule("MacBook Internal Keyboard")
  .condition(ifDevice(DEVICES.apple))
  .manipulators([
    map("right_command", null, "any")
      .to(toSetVar(LAYER.lower, 1))
      .toAfterKeyUp(toSetVar(LAYER.lower, 0))
      .toIfAlone("escape"),
  ]);

const realforceRule = rule("REALFORCE")
  .condition(ifDevice(DEVICES.realforceR2))
  .manipulators([
    map("spacebar", null, "any")
      .condition(ifDeviceExists(DEVICES.progresTouchRetroTiny))
      .to(toSetVar(LAYER.lower, 1))
      .toAfterKeyUp(toSetVar(LAYER.lower, 0))
      .toIfAlone("return_or_enter"),
  ]);

const profile: KarabinerProfileExt = {
  complex_modifications: complexModifications([
    backspaceRule,
    arrowRule,
    capsRule,
    lowerRule,
    macRule,
    realforceRule,
  ]),
  devices: [
    device(DEVICES.macBook2018, {
      simple_modifications: simpleModifications([
        map("fn").to("left_command"),
        map("left_command").to("escape"),
        map("right_option").to("fn"),
      ]),
    }),
    device(DEVICES.progresTouchRetroTiny, {
      simple_modifications: simpleModifications([
        map("left_command").to("left_control"),
        map("left_control").to("left_command"),
        map("escape").to("grave_accent_and_tilde"),
        map("right_control").to("japanese_eisuu"),
      ]),
    }),
    device(DEVICES.realforceR2, {
      simple_modifications: simpleModifications([
        map("left_command").to("left_control"),
        map("left_control").to("left_command"),
        map("right_command").to("japanese_eisuu"),
        map("keypad_num_lock").toNone(),
      ]),
    }),
    device(DEVICES.mint60, {
      simple_modifications: simpleModifications([
        map("left_command").to("left_control"),
        map("left_control").to("left_command"),
      ]),
    }),
  ],
  fn_function_keys: defaultFnFunctionKeys,
  name: "Default profile",
  parameters: {
    delay_milliseconds_before_open_device: 1000,
  },
  selected: true,
  simple_modifications: [],
  virtual_hid_keyboard: {
    country_code: 0,
    indicate_sticky_modifier_keys_state: true,
    mouse_key_xy_scale: 100,
  },
};

const config: KarabinerConfigExt = {
  global: defaultGlobals,
  profiles: [profile],
};

Deno.writeTextFile(
  new URL("karabiner.json", import.meta.url),
  JSON.stringify(config, null, 4),
);
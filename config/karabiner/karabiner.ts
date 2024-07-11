#!/usr/bin/env -S deno run --check --allow-write
import {
  complexModifications,
  defaultFnFunctionKeys,
  defaultGlobals,
  device,
  FromKeyCode,
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
  akl680: {
    product_id: 591,
    vendor_id: 1452,
  },
} as const satisfies Record<string, KeyboardIdentifier>;

const LAYER_VAR = "layer";

const LAYERS = {
  normal: 0,
  lower: 1,
} as const;

type Layer = keyof typeof LAYERS;

function ifLayer(layer: Layer) {
  return ifVar(LAYER_VAR, LAYERS[layer]);
}

function toMOLayer(layer: Layer) {
  return toSetVar(LAYER_VAR, LAYERS[layer], LAYERS.normal);
}

function backspaceRule() {
  return rule("Exchange Command+Backspace/Delete and Option+Backspace/Delete")
    .manipulators([
      map("⌫", "command", "shift").to("⌫", "option"),
      map("⌫", "option", "shift").to("⌫", "command"),
      map("⌦", "command", "shift").to("⌦", "option"),
      map("⌦", "option", "shift").to("⌦", "command"),
    ]);
}

const arrowKeys = ["←", "↓", "↑", "→"] as const;

function modArrowRule() {
  return rule("Exchange command + arrow keys with option + arrow keys")
    .manipulators(
      arrowKeys.flatMap((key) => [
        map(key, ["command", "option"], "any").to(key, ["command", "option"]),
        map(key, "command", "any").to(key, "option"),
        map(key, "option", "any").to(key, "command"),
      ]),
    );
}

function mapArrows(
  up: FromKeyCode,
  left: FromKeyCode,
  down: FromKeyCode,
  right: FromKeyCode,
) {
  const alt = [left, down, up, right];
  return arrowKeys.flatMap((key, i) => [
    map(alt[i], ["command", "option"], "any").to(key, ["command", "option"]),
    map(alt[i], "command", "any").to(key, "option"),
    map(alt[i], "option", "any").to(key, "command"),
    map(alt[i], null, "any").to(key),
  ]);
}

function capsLockRule() {
  return rule("Change Caps Lock")
    .manipulators([
      map("caps_lock", "shift")
        .to("left_command", "shift")
        .toIfAlone(stroke("->")),
      map("caps_lock", "command")
        .to("left_command", "shift")
        .toIfAlone(stroke("=>")),
      map("caps_lock").condition(ifLayer("lower"))
        .to("left_command", "shift")
        .toIfAlone(stroke("-")),
      map("caps_lock", null, "any")
        .to("left_command", "shift")
        .toIfAlone(stroke("_")),
    ]);
}

function lowerRule() {
  return rule("Lower Layer")
    .manipulators([
      withCondition(ifLayer("lower"))([
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

        ...mapArrows("i", "j", "k", "l"),
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
        .condition(ifLayer("normal"))
        .to(toMOLayer("lower"))
        .toIfAlone("escape"),
    ]);
}

function macRule() {
  return rule("MacBook Internal Keyboard")
    .condition(ifDevice(DEVICES.apple))
    .manipulators([
      map("right_command", null, "any")
        .condition(ifLayer("normal"))
        .to(toMOLayer("lower"))
        .toIfAlone("escape"),
    ]);
}

function realforceRule() {
  return rule("REALFORCE")
    .condition(ifDevice(DEVICES.realforceR2))
    .manipulators([
      map("spacebar", null, "any")
        .condition(ifDeviceExists(DEVICES.progresTouchRetroTiny))
        .condition(ifLayer("normal"))
        .to(toMOLayer("lower"))
        .toIfAlone("return_or_enter"),
    ]);
}

const profile: KarabinerProfileExt = {
  complex_modifications: complexModifications([
    backspaceRule(),
    modArrowRule(),
    capsLockRule(),
    lowerRule(),
    macRule(),
    realforceRule(),
  ], {
    "basic.to_if_alone_timeout_milliseconds": 250,
    "basic.to_if_held_down_threshold_milliseconds": 250,
  }),
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
        map("escape").to("grave_accent_and_tilde"),
        map("left_command").to("left_control"),
        map("left_control").to("left_command"),
        map("right_control").to("japanese_eisuu"),
      ]),
    }),
    device(DEVICES.realforceR2, {
      simple_modifications: simpleModifications([
        map("keypad_num_lock").toNone(),
        map("left_command").to("left_control"),
        map("left_control").to("left_command"),
        map("right_command").to("japanese_eisuu"),
      ]),
    }),
    device(DEVICES.mint60, {
      simple_modifications: simpleModifications([
        map("left_command").to("left_control"),
        map("left_control").to("left_command"),
      ]),
    }),
    device(DEVICES.akl680, {
      simple_modifications: simpleModifications([
        map("left_option").to("left_control"),
        map("left_control").to("left_command"),
        map("left_command").to("left_option"),
        map("escape").to("grave_accent_and_tilde"),
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

function keySorter(_key: string, value: any) {
  if (typeof value === "object" && value !== null && !Array.isArray(value)) {
    return Object.fromEntries(
      Object.entries(value).sort(([ak], [bk]) => ak.localeCompare(bk)),
    );
  }
  return value;
}

Deno.writeTextFile(
  new URL("karabiner.json", import.meta.url),
  JSON.stringify(config, keySorter, 4),
);

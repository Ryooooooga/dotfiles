#!/usr/bin/env -S deno run --check --allow-write
import { complexModifications } from "./libs/complex_modifications.ts";
import { defaultProfile, saveConfig } from "./libs/config.ts";
import { simpleModifications } from "./libs/simple_modifications.ts";
import { toStroke } from "./libs/to_stroke.ts";
import {
  BasicManipulatorBuilder,
  FromKeyCode,
  ifDevice,
  ifDeviceExists,
  ifInputSource,
  ifVar,
  map,
  rule,
  toRemoveNotificationMessage,
  withCondition,
  withMapper,
} from "./libs/deps.ts";
import { DEVICES } from "./rules/device.ts";
import { Layers } from "./libs/layer.ts";

const layer = new Layers("layer", [
  "default",
  "lower",
  "raise",
]);

function backspaceRule() {
  return rule(
    "Exchange Command+Backspace/Delete and Option+Backspace/Delete",
  ).manipulators([
    withCondition(layer.ifActive("default"))([
      map("⌫", "command", "shift").to("⌫", "option"),
      map("⌫", "option", "shift").to("⌫", "command"),
      map("⌦", "command", "shift").to("⌦", "option"),
      map("⌦", "option", "shift").to("⌦", "command"),
    ]),
    withCondition(layer.ifActive("lower"))([
      map("⌫", "command", "shift").to("⌦", "option"),
      map("⌫", "option", "shift").to("⌦", "command"),
      map("⌫", null, "any").to("⌦"),
    ]),
    withCondition(layer.ifActive("raise"))([
      map("⌫", "command", "shift").to("⌦", "option"),
      map("⌫", "option", "shift").to("⌦", "command"),
      map("⌫", null, "any").to("⌦"),
    ]),
  ]);
}

const arrowKeys = ["←", "↓", "↑", "→"] as const;

function modArrowRule() {
  return rule(
    "Exchange command + arrow keys with option + arrow keys",
  ).manipulators(
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
  return rule("Change Caps Lock").manipulators([
    map("caps_lock", "shift")
      .to("left_command", "shift")
      .toIfAlone(toStroke("->")),
    map("caps_lock", "command")
      .to("left_command", "shift")
      .toIfAlone(toStroke("=>")),
    map("caps_lock")
      .condition(layer.ifActive("lower"))
      .to("left_command", "shift")
      .toIfAlone(toStroke("-")),
    map("caps_lock", null, "any")
      .to("left_command", "shift")
      .toIfAlone(toStroke("_")),
  ]);
}

function lowerRule() {
  return rule("Lower Layer").manipulators([
    withCondition(layer.ifActive("lower"))([
      map("1").to(toStroke("!")),
      map("2").to(toStroke("@")),
      map("3").to(toStroke("#")),
      map("4").to(toStroke("$")),
      map("5").to(toStroke("%")),

      map("6").to(toStroke("^")),
      map("7").to(toStroke("&")),
      map("8").to(toStroke("*")),
      map("9").to(toStroke("(")),
      map("0").to(toStroke(")")),
      map("-").to(toStroke("_")),
      map("=").to(toStroke("+")),

      map("q").to(toStroke("!")),
      map("w").to(toStroke("@")),
      map("e").to(toStroke("#")),
      map("r").to(toStroke("$")),
      map("t").to(toStroke("%")),

      map("a").to(toStroke("^")),
      map("s").to(toStroke("&")),
      map("d").to(toStroke("*")),
      map("f").to(toStroke("=")),
      map("g").to(toStroke("+")),

      ...mapArrows("i", "j", "k", "l"),
      map("u", null, "any").to("home"),
      map("o", null, "any").to("end"),
      map("p", null, "any").to("page_up"),
      map(";", null, "any").to("page_down"),

      map("z").to(toStroke("(")),
      map("x").to(toStroke(")")),
      map("c").to(toStroke("/")),
      map("v").to(toStroke("?")),

      map("[").to(toStroke("{")),
      map("]").to(toStroke("}")),
    ]),
    map("right_option", null, "any")
      .condition(layer.ifActive("default"))
      .to(layer.toMO("lower"))
      .toIfAlone("escape"),
  ]);
}

function raiseRule() {
  return rule("Raise Layer").manipulators([
    withCondition(layer.ifActive("raise"))([
      ...mapArrows("w", "a", "s", "d"),
      map("q", null, "any").to("home"),
      map("e", null, "any").to("end"),
      map("r", null, "any").to("page_up"),
      map("f", null, "any").to("page_down"),

      map("z").to(toStroke("`")),
      map("x").to(toStroke("~")),
    ]),
    map("right_control", null, "any")
      .condition(layer.ifActive("default"))
      .to(layer.toMO("raise")),
  ]);
}

function macRule() {
  return rule("MacBook Internal Keyboard")
    .condition(ifDevice(DEVICES.apple))
    .manipulators([
      map("right_command", null, "any")
        .condition(layer.ifActive("default"))
        .to(layer.toMO("lower"))
        .toIfAlone("escape"),
    ]);
}

function realforceRule() {
  return rule("REALFORCE")
    .condition(ifDevice(DEVICES.realforceR2))
    .manipulators([
      withCondition(ifDeviceExists(DEVICES.progresTouchRetroTiny))([
        map("spacebar", null, "any")
          .condition(layer.ifActive("default"))
          .to(layer.toMO("lower"))
          .toIfAlone("return_or_enter"),
        map("b", null, "any")
          .to("delete_or_backspace"),
      ]),
    ]);
}

/**
 * TSRNGN
 *
 * +----+----+----+----+----+----+----+----+----+----+----+----+----+----+
 * | `  | 1  | 2  | 3  | 4  | 5  | 6  | 7  | 8  | 9  | 0  | '  | =  | BS |
 * +----+----+----+----+----+----+----+----+----+----+----+----+----+----+
 * |Tab | Q  | W  | E  | D  | L  | V  | Y  | R  | J  | P  | [  | ]  | |  |
 * +----+----+----+----+----+----+----+----+----+----+----+----+----+----+
 * |Caps| A  | U  | O  | I  | G  | H  | T  | S  | K  | ,  | .  | Enter   |
 * +----+----+----+----+----+----+----+----+----+----+----+----+---------+
 * |LShf| Z  | X  | C  | F  | B  | N  | M  | -  | ;  | /  |     RShf     |
 * +----+----+----+----+----+----+----+----+----+----+----+--------------+
 */
export const tsrngnMap = {
  "`": "`",
  1: "1",
  2: "2",
  3: "3",
  4: "4",
  5: "5",
  6: "6",
  7: "7",
  8: "8",
  9: "9",
  0: "0",
  "-": "'",
  "=": "=",

  q: "q",
  w: "w",
  e: "e",
  r: "d",
  t: "l",
  y: "v",
  u: "y",
  i: "r",
  o: "j",
  p: "p",
  "[": "[",
  "]": "]",
  "\\": "\\",

  a: "a",
  s: "u",
  d: "o",
  f: "i",
  g: "g",
  h: "h",
  j: "t",
  k: "s",
  l: "k",
  ";": ",",
  "'": ".",

  z: "z",
  x: "x",
  c: "c",
  v: "f",
  b: "b",
  n: "n",
  m: "m",
  ",": "-",
  ".": ";",
  "/": "/",
} as const;

function tsrngnRule() {
  const modeVar = "tsrngn";

  function remapKeys() {
    const keyMap = Object.fromEntries(
      Object.entries(tsrngnMap).filter(([from, to]) => from !== to),
    ) as Partial<typeof tsrngnRule>;

    return withMapper(keyMap)((from, to) => map(from, null, "shift").to(to));
  }

  enum Mode {
    off,
    ja,
    full,
  }

  function switchMode(mode: Mode, message: string, m: BasicManipulatorBuilder) {
    return m
      .toVar(modeVar, mode)
      .parameters({ "basic.to_delayed_action_delay_milliseconds": 2000 })
      .toNotificationMessage(modeVar, message)
      .toDelayedAction(
        toRemoveNotificationMessage(modeVar),
        toRemoveNotificationMessage(modeVar),
      );
  }

  return rule("JA tsrngn").manipulators([
    withCondition(
      ifVar(modeVar, 1),
      ifInputSource({ language: "ja" }),
    )([remapKeys()]),
    withCondition(ifVar(modeVar, 2))([remapKeys()]),
    switchMode(
      Mode.off,
      "QWERTY MODE",
      map("page_up").condition(layer.ifActive("raise")),
    ),
    switchMode(
      Mode.off,
      "QWERTY MODE",
      map("page_down").condition(
        layer.ifActive("raise"),
        ifVar(modeVar, Mode.full),
      ),
    ),
    switchMode(
      Mode.ja,
      "TSRNGN MODE",
      map("page_down").condition(
        layer.ifActive("raise"),
        ifVar(modeVar, Mode.off),
      ),
    ),
    switchMode(
      Mode.full,
      "FULL TSRNGN MODE",
      map("page_down").condition(
        layer.ifActive("raise"),
        ifVar(modeVar, Mode.ja),
      ),
    ),
  ]);
}

const profile = defaultProfile({
  complex_modifications: complexModifications(
    [
      backspaceRule(),
      modArrowRule(),
      capsLockRule(),
      lowerRule(),
      raiseRule(),
      macRule(),
      realforceRule(),
      tsrngnRule(),
    ],
  ),
  simple_modifications: simpleModifications([
    map("keypad_num_lock").toNone(),
    map("left_command").to("left_control"),
    map("left_control").to("left_command"),
  ]),
  devices: [
    {
      identifiers: DEVICES.macBook2018,
      simple_modifications: simpleModifications([
        map("fn").to("left_command"),
        map("left_command").to("escape"),
        map("left_control").to("left_control"),
        map("right_option").to("fn"),
      ]),
    },
    {
      identifiers: DEVICES.progresTouchRetroTiny,
      simple_modifications: simpleModifications([
        map("escape").to("grave_accent_and_tilde"),
        map("right_control").to("japanese_eisuu"),
      ]),
    },
    {
      identifiers: DEVICES.realforceR2,
      simple_modifications: simpleModifications([
        map("right_command").to("right_control"),
      ]),
    },
    {
      identifiers: DEVICES.akl680,
      simple_modifications: simpleModifications([
        map("escape").to("grave_accent_and_tilde"),
        map("right_option").to("right_command"),
      ]),
    },
    {
      identifiers: DEVICES.mk23(),
      ignore: false,
    },
    {
      identifiers: DEVICES.mk23(false),
      ignore: true,
    },
    {
      identifiers: DEVICES.mk24(),
      ignore: false,
    },
    {
      identifiers: DEVICES.mk24(false),
      ignore: true,
    },
  ],
});

await saveConfig(new URL("karabiner.json", import.meta.url), {
  profiles: [profile],
});

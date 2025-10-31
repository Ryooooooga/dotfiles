#!/usr/bin/env -S deno run --check --allow-write
import { complexModifications } from "./libs/complex_modifications.ts";
import { defaultProfile, saveConfig } from "./libs/config.ts";
import { simpleModifications } from "./libs/simple_modifications.ts";
import {
  FromKeyCode,
  ifDevice,
  map,
  rule,
  toNone,
  toTypeSequence,
  withCondition,
} from "./libs/deps.ts";
import { Layers } from "./libs/layer.ts";
import {
  rotateTsrngnMode,
  toTsrngnMode,
  withTsrngnKeys,
  withTsrngnMode,
} from "./libs/tsrngn.ts";
import { DEVICES } from "./device.ts";

const layers = new Layers("layer", [
  "default",
  "lower",
]);

function backspaceRule() {
  return rule(
    "Exchange Command+Backspace/Delete and Option+Backspace/Delete",
  ).manipulators([
    withCondition(layers.ifActive("default"))([
      map("⌫", "command", "shift").to("⌫", "option"),
      map("⌫", "option", "shift").to("⌫", "command"),
      map("⌦", "command", "shift").to("⌦", "option"),
      map("⌦", "option", "shift").to("⌦", "command"),
    ]),
    withCondition(layers.ifActive("lower"))([
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
      .toIfAlone(toTypeSequence("->")),
    map("caps_lock", "command")
      .to("left_command", "shift")
      .toIfAlone(toTypeSequence("=>")),
    map("caps_lock", null, "any")
      .to("left_command", "shift")
      .toIfAlone(toTypeSequence("_")),
  ]);
}

function lowerRule() {
  return rule("Lower Layer").manipulators([
    withCondition(layers.ifActive("lower"))([
      map("1").toTypeSequence("!"),
      map("2").toTypeSequence("@"),
      map("3").toTypeSequence("#"),
      map("4").toTypeSequence("$"),
      map("5").toTypeSequence("%"),

      map("6").toTypeSequence("^"),
      map("7").toTypeSequence("&"),
      map("8").toTypeSequence("*"),
      map("9").toTypeSequence("("),
      map("0").toTypeSequence(")"),
      map("-").toTypeSequence("_"),
      map("=").toTypeSequence("+"),

      map("q").toTypeSequence("!"),
      map("w").toTypeSequence("@"),
      map("e").toTypeSequence("#"),
      map("r").toTypeSequence("$"),
      map("t").toTypeSequence("%"),

      map("a").toTypeSequence("^"),
      map("s").toTypeSequence("&"),
      map("d").toTypeSequence("*"),
      map("f").toTypeSequence("="),
      map("g").toTypeSequence("+"),

      ...mapArrows("i", "j", "k", "l"),
      map("u", null, "any").to("home"),
      map("o", null, "any").to("end"),
      map("p", null, "any").to("page_up"),
      map(";", null, "any").to("page_down"),

      map("z").toTypeSequence("("),
      map("x").toTypeSequence(")"),
      map("c").toTypeSequence("/"),
      map("v").toTypeSequence("?"),

      map("[").toTypeSequence("{"),
      map("]").toTypeSequence("}"),
    ]),
    map("right_option", null, "any")
      .condition(layers.ifActive("default"))
      .to(layers.toMO("lower"))
      .toIfAlone("escape"),
  ]);
}

function macRule() {
  return rule("MacBook Internal Keyboard")
    .condition(ifDevice(DEVICES.apple))
    .manipulators([
      map("right_command", null, "any")
        .condition(layers.ifActive("default"))
        .to(layers.toMO("lower"))
        .toIfAlone("escape"),
    ]);
}

function tsrngnRule() {
  return rule("JA tsrngn").manipulators([
    withTsrngnMode([
      withTsrngnKeys(({ from, to }) => map(from, null, "shift").to(to)),
    ]),
    toTsrngnMode("off", map("f19")),
    rotateTsrngnMode(() => map("f20")),
  ]);
}

const profile = defaultProfile({
  complex_modifications: complexModifications(
    [
      backspaceRule(),
      modArrowRule(),
      capsLockRule(),
      lowerRule(),
      macRule(),
      tsrngnRule(),
    ],
  ),
  simple_modifications: simpleModifications({
    keypad_num_lock: toNone(),
    left_command: "left_control",
    left_control: "left_command",
  }),
  devices: [
    {
      identifiers: DEVICES.macBook2018,
      simple_modifications: simpleModifications({
        fn: "left_command",
        left_command: "escape",
        left_control: "left_control",
        right_option: "fn",
      }),
    },
    {
      identifiers: DEVICES.progresTouchRetroTiny,
      simple_modifications: simpleModifications({
        escape: "grave_accent_and_tilde",
        right_control: "japanese_eisuu",
      }),
    },
  ],
});

await saveConfig(new URL("karabiner.json", import.meta.url), {
  profiles: [profile],
});

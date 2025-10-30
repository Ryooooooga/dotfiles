import {
  BasicManipulatorBuilder,
  ifInputSource,
  Manipulator,
  ManipulatorBuilder,
  ManipulatorMap,
  toRemoveNotificationMessage,
  withCondition,
  withMapper,
} from "./deps.ts";
import { Layers } from "./layer.ts";

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
const tsrngnMap = [
  { from: "`", to: "`" },
  { from: "1", to: "1" },
  { from: "2", to: "2" },
  { from: "3", to: "3" },
  { from: "4", to: "4" },
  { from: "5", to: "5" },
  { from: "6", to: "6" },
  { from: "7", to: "7" },
  { from: "8", to: "8" },
  { from: "9", to: "9" },
  { from: "0", to: "0" },
  { from: "-", to: "'" },
  { from: "=", to: "=" },

  { from: "q", to: "q" },
  { from: "w", to: "w" },
  { from: "e", to: "e" },
  { from: "r", to: "d" },
  { from: "t", to: "l" },
  { from: "y", to: "v" },
  { from: "u", to: "y" },
  { from: "i", to: "r" },
  { from: "o", to: "j" },
  { from: "p", to: "p" },
  { from: "[", to: "[" },
  { from: "]", to: "]" },
  { from: "\\", to: "\\" },

  { from: "a", to: "a" },
  { from: "s", to: "u" },
  { from: "d", to: "o" },
  { from: "f", to: "i" },
  { from: "g", to: "g" },
  { from: "h", to: "h" },
  { from: "j", to: "t" },
  { from: "k", to: "s" },
  { from: "l", to: "k" },
  { from: ";", to: "," },
  { from: "'", to: "." },

  { from: "z", to: "z" },
  { from: "x", to: "x" },
  { from: "c", to: "c" },
  { from: "v", to: "f" },
  { from: "b", to: "b" },
  { from: "n", to: "n" },
  { from: "m", to: "m" },
  { from: ",", to: "-" },
  { from: ".", to: ";" },
  { from: "/", to: "/" },
] as const;

const MODES = ["off", "jaOnly", "always"] as const;
type Mode = typeof MODES[number];

const tsrngnLayers = new Layers("tsrngn", MODES);

export const withTsrngnKeys = withMapper(
  tsrngnMap.filter((m) => m.from !== m.to),
);

export function withTsrngnMode(
  manipulators:
    | ManipulatorMap
    | Array<Manipulator | ManipulatorBuilder | ManipulatorMap>,
): ManipulatorBuilder {
  return withMapper([
    [tsrngnLayers.ifActive("jaOnly"), ifInputSource({ language: "ja" })],
    [tsrngnLayers.ifActive("always")],
  ])((cond) => withCondition(...cond)(manipulators));
}

function switchMode(
  mode: Mode,
  m: BasicManipulatorBuilder,
) {
  const messageId = "tsrngn";

  const messages = {
    off: "QWERTY MODE",
    jaOnly: "TSRNGN MODE",
    always: "FULL TSRNGN MODE",
  } as const satisfies Record<Mode, string>;

  return m
    .to(tsrngnLayers.toTO(mode))
    .parameters({ "basic.to_delayed_action_delay_milliseconds": 2000 })
    .toNotificationMessage(messageId, messages[mode])
    .toDelayedAction(
      toRemoveNotificationMessage(messageId),
      toRemoveNotificationMessage(messageId),
    );
}

export function toTsrngnMode(mode: Mode, m: BasicManipulatorBuilder) {
  return switchMode(mode, m);
}

export function rotateTsrngnMode(m: () => BasicManipulatorBuilder) {
  return withMapper([
    [tsrngnLayers.ifActive("always"), "off"],
    [tsrngnLayers.ifActive("off"), "jaOnly"],
    [tsrngnLayers.ifActive("jaOnly"), "always"],
  ])(([cond, mode]) => withCondition(cond)([switchMode(mode, m())]));
}

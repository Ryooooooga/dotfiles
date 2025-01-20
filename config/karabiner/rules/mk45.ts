import {
  ifDevice,
  map,
  rule,
  withCondition,
  withMapper,
} from "../libs/deps.ts";
import { Layers } from "../libs/layer.ts";
import { DEVICES } from "./device.ts";

/**
 * mk45
 *
 * Builtin:
 * +-----+-----+-----+-----+-----+-----+  +-----+-----+-----+-----+-----+-----+  +-----+
 * | Tab |  Q  |  W  |  E  |  R  |  T  |  |  Y  |  U  |  I  |  O  |  P  |  BS |  | F18 |
 * |     |     |     |     |     |     |  |     |     |     |     |     |     |  |     |
 * +-----+-----+-----+-----+-----+-----+  +-----+-----+-----+-----+-----+-----+  +-----+
 * | Caps|  A  |  S  |  D  |  F  |  G  |  |  H  |  J  |  K  |  L  |  ;  |  '  |  | F19 |
 * |     |     |     |     |     |     |  |     |     |     |     |     |     |  |     |
 * +-----+-----+-----+-----+-----+-----+  +-----+-----+-----+-----+-----+-----+  +-----+
 * | LShf|  Z  |  X  |  C  |  V  |  B  |  |  N  |  M  |  ,  |  .  |  /  |
 * |     |     |     |     |     |     |  |     |     |     |     |     |  +-----+-----+-----+
 * +-----+-----+-----+-----+-----+-----+  +-----+-----+-----+-----+-----+  | Left| F20 |Right|
 * | LCtl| LCmd| LOpt|  `  |   Space   |  |Enter| Esc |  [  |  ]  |  -  |  |     |     |     |
 * |     |     |     |     |           |  |     |     |     |     |     |  +-----+-----+-----+
 * +-----+-----+-----+-----+-----+-----+  +-----+-----+-----+-----+-----+
 */
const KEYS = {
  button1: "f18",
  button2: "f19",
  knobClick: "f20",
  knobLeft: "left_arrow",
  knobRight: "right_arrow",
} as const;

const VARS = {
  layer: "mk45_layer",
};

const mk45Layers = new Layers(VARS.layer, [
  "default",
  "lower",
  "raise",
  "media",
]);

/**
 * Layer 0: default
 * +-----+-----+-----+-----+-----+-----+  +-----+-----+-----+-----+-----+-----+  +-----+
 * | Tab |  Q  |  W  |  E  |  R  |  T  |  |  Y  |  U  |  I  |  O  |  P  | BS  |  | F18 |
 * |     |     |     |     |     |     |  |     |     |     |     |     |     |  |     |
 * +-----+-----+-----+-----+-----+-----+  +-----+-----+-----+-----+-----+-----+  +-----+
 * | Caps|  A  |  S  |  D  |  F  |  G  |  |  H  |  J  |  K  |  L  |  ;  |  '  |  | F19 |
 * |     |     |     |     |     |     |  |     |     |     |     |     |     |  |     |
 * +-----+-----+-----+-----+-----+-----+  +-----+-----+-----+-----+-----+-----+  +-----+
 * | LShf|  Z  |  X  |  C  |  V  |  B  |  |  N  |  M  |  ,  |  .  |  /  |
 * |     |     |     |     |     |     |  |     |     |     |     |     |  +-----+-----+-----+
 * +-----+-----+-----+-----+-----+-----+  +-----+-----+-----+-----+-----+  | Left| Mute|Right|
 * | LCmd|LCtrl| LOpt|  `  |   Space   |  |Enter| Esc |  -  |  =  |  \  |  |     | MO3 |     |
 * |     |     |     | MO2 |    MO1    |  | RShf| MO1 |     |     | MO2 |  +-----+-----+-----+
 * +-----+-----+-----+-----+-----+-----+  +-----+-----+-----+-----+-----+
 */
function defaultLayer() {
  return {
    left: [
      map("`", null, "any")
        .to(mk45Layers.toMO("raise"))
        .toIfAlone("`"),
      map("spacebar", null, "any")
        .toIfAlone("spacebar")
        .to(mk45Layers.toMO("lower")),
    ],
    right: [
      map("return_or_enter", null, "any")
        .toIfAlone("return_or_enter")
        .to("right_shift"),
      map("escape", null, "any")
        .toIfAlone("escape")
        .to(mk45Layers.toMO("lower")),
      map("\\", null, "any")
        .toIfAlone("\\")
        .to(mk45Layers.toMO("raise")),

      map(KEYS.knobClick, null, "any")
        .to(mk45Layers.toMO("media"))
        .toIfAlone("mute"),
    ],
  };
}

/**
 * Layer 1: lower
 * +-----+-----+-----+-----+-----+-----+  +-----+-----+-----+-----+-----+-----+  +-----+
 * |  ~  |  !  |  @  |  #  |  $  |  %  |  |  ^  |  &  |  *  |  (  |  )  |     |  |     |
 * |     |     |     |     |     |     |  |     |     |     |     |     |     |  |     |
 * +-----+-----+-----+-----+-----+-----+  +-----+-----+-----+-----+-----+-----+  +-----+
 * |  `  |  1  |  2  |  3  |  4  |  5  |  |  6  |  7  |  8  |  9  |  0  | Del |  |     |
 * | Caps|     |     |     |     |     |  |     |     |     |     |     |     |  |     |
 * +-----+-----+-----+-----+-----+-----+  +-----+-----+-----+-----+-----+-----+  +-----+
 * |     |  {  |  }  |  [  |  ]  |     |  |     |     | Home| Up  | End |
 * |     |     |     |     |     |     |  |     |     |     |     |     |  +-----+-----+-----+
 * +-----+-----+-----+-----+-----+-----+  +-----+-----+-----+-----+-----+  | Up  |     | Down|
 * |     |     |     |     |           |  |     |     | Left| Down|Right|  |     |     |     |
 * |     |     |     |     |           |  |     |     |     |     |     |  +-----+-----+-----+
 * +-----+-----+-----+-----+-----+-----+  +-----+-----+-----+-----+-----+
 */
function lowerLayer() {
  return {
    left: [
      map("tab", null, "any").to("`", "shift"),
      map("q", null, "any").to("1", "shift"),
      map("w", null, "any").to("2", "shift"),
      map("e", null, "any").to("3", "shift"),
      map("r", null, "any").to("4", "shift"),
      map("t", null, "any").to("5", "shift"),

      map("caps_lock", null, "any")
        .to("left_shift", "left_command")
        .toIfAlone("`"),
      map("a", null, "any").to("1"),
      map("s", null, "any").to("2"),
      map("d", null, "any").to("3"),
      map("f", null, "any").to("4"),
      map("g", null, "any").to("5"),

      map("z", null, "any").toTypeSequence("{"),
      map("x", null, "any").toTypeSequence("}"),
      map("c", null, "any").toTypeSequence("["),
      map("v", null, "any").toTypeSequence("]"),
    ],
    right: [
      map("y", null, "any").to("6", "shift"),
      map("u", null, "any").to("7", "shift"),
      map("i", null, "any").to("8", "shift"),
      map("o", null, "any").to("9", "shift"),
      map("p", null, "any").to("0", "shift"),

      map("h", null, "any").to("6"),
      map("j", null, "any").to("7"),
      map("k", null, "any").to("8"),
      map("l", null, "any").to("9"),
      map(";", null, "any").to("0"),

      map(",", null, "any").to("home"),
      map("/", null, "any").to("end"),

      withMapper(
        {
          "'": "delete_forward",
          ".": "up_arrow",
          "-": "left_arrow",
          "=": "down_arrow",
          "\\": "right_arrow",
          [KEYS.knobLeft]: "up_arrow",
          [KEYS.knobRight]: "down_arrow",
        } as const,
      )((from, to) =>
        withMapper([
          [["option", "shift"], ["command"]],
          [["command", "shift"], ["option"]],
          [[null, "any"], []],
        ])(([fromMod, toMod]) => map(from, ...fromMod).to(to, ...toMod))
      ),
    ],
  };
}

/**
 * Layer 2: raise
 * +-----+-----+-----+-----+-----+-----+  +-----+-----+-----+-----+-----+-----+  +-----+
 * |     | (|) | {|} | [|] | <|> |     |  |  7  |  8  |  9  |  (  |  )  |     |  |     |
 * |     |     |     |     |     |     |  |     |     |     |     |     |     |  |     |
 * +-----+-----+-----+-----+-----+-----+  +-----+-----+-----+-----+-----+-----+  +-----+
 * |     |  (  |  )  |  <  |  >  |     |  |  4  |  5  |  6  |  +  |  -  | Del |  |     |
 * |     |     |     |     |     |     |  |     |     |     |     |     |     |  |     |
 * +-----+-----+-----+-----+-----+-----+  +-----+-----+-----+-----+-----+-----+  +-----+
 * |     |  {  |  }  |  [  |  ]  |     |  |  1  |  2  |  3  |  *  |  /  |
 * |     |     |     |     |     |     |  |     |     |     |     |     |  +-----+-----+-----+
 * +-----+-----+-----+-----+-----+-----+  +-----+-----+-----+-----+-----+  |WhlUp|     |WhlDn|
 * |     |     |     |     |           |  |  0  |     |  .  |  =  |     |  |     |     |     |
 * |     |     |     |     |           |  |     |     |     |     |     |  +-----+-----+-----+
 * +-----+-----+-----+-----+-----+-----+  +-----+-----+-----+-----+-----+
 */
function raiseLayer() {
  return {
    left: [
      map("q", null, "any").toTypeSequence("()←"),
      map("w", null, "any").toTypeSequence("{}←"),
      map("e", null, "any").toTypeSequence("[]←"),
      map("r", null, "any").toTypeSequence("<>←"),

      map("a", null, "any").toTypeSequence("("),
      map("s", null, "any").toTypeSequence(")"),
      map("d", null, "any").toTypeSequence("<"),
      map("f", null, "any").toTypeSequence(">"),

      map("z", null, "any").toTypeSequence("{"),
      map("x", null, "any").toTypeSequence("}"),
      map("c", null, "any").toTypeSequence("["),
      map("v", null, "any").toTypeSequence("]"),
    ],
    right: [
      map("y", null, "any").to("7"),
      map("u", null, "any").to("8"),
      map("i", null, "any").to("9"),
      map("o", null, "any").toTypeSequence("("),
      map("p", null, "any").toTypeSequence(")"),

      map("h", null, "any").to("4"),
      map("j", null, "any").to("5"),
      map("k", null, "any").to("6"),
      map("l", null, "any").toTypeSequence("+"),
      map(";", null, "any").toTypeSequence("-"),

      map("n", null, "any").to("1"),
      map("m", null, "any").to("2"),
      map(",", null, "any").to("3"),
      map(".", null, "any").toTypeSequence("*"),
      map("/", null, "any").toTypeSequence("/"),

      map("return_or_enter", null, "any").to("0"),
      map("-", null, "any").to("."),
      map("=", null, "any").to("="),

      withMapper(
        {
          "'": "delete_forward",
        } as const,
      )((from, to) =>
        withMapper([
          [["option", "shift"], ["command"]],
          [["command", "shift"], ["option"]],
          [[null, "any"], []],
        ])(([fromMod, toMod]) => map(from, ...fromMod).to(to, ...toMod))
      ),

      map(KEYS.knobLeft, null, "any").toMouseKey({ vertical_wheel: -256 }),
      map(KEYS.knobRight, null, "any").toMouseKey({ vertical_wheel: 256 }),
    ],
  };
}

/**
 * Layer 3: media
 * +-----+-----+-----+-----+-----+-----+  +-----+-----+-----+-----+-----+-----+  +-----+
 * |     | F1  | F2  | F3  | F4  |     |  |     |     |     |     |     |     |  |     |
 * |     |     |     |     |     |     |  |     |     |     |     |     |     |  |     |
 * +-----+-----+-----+-----+-----+-----+  +-----+-----+-----+-----+-----+-----+  +-----+
 * |     | F5  | F6  | F7  | F8  |     |  |     |     |     |     |     |     |  |     |
 * |     |     |     |     |     |     |  |     |     |     |     |     |     |  |     |
 * +-----+-----+-----+-----+-----+-----+  +-----+-----+-----+-----+-----+-----+  +-----+
 * |     | F9  | F10 | F11 | F12 |     |  |     |     |     |     |     |
 * |     |     |     |     |     |     |  |     |     |     |     |     |  +-----+-----+-----+
 * +-----+-----+-----+-----+-----+-----+  +-----+-----+-----+-----+-----+  |VolDn|     |VolUp|
 * |     |     |     |     |           |  |     |     |     |     |     |  |     |     |     |
 * |     |     |     |     |           |  |     |     |     |     |     |  +-----+-----+-----+
 * +-----+-----+-----+-----+-----+-----+  +-----+-----+-----+-----+-----+
 */
function mediaLayer() {
  return {
    left: [
      map("q", null, "any").to("f1"),
      map("w", null, "any").to("f2"),
      map("e", null, "any").to("f3"),
      map("r", null, "any").to("f4"),

      map("a", null, "any").to("f5"),
      map("s", null, "any").to("f6"),
      map("d", null, "any").to("f7"),
      map("f", null, "any").to("f8"),

      map("z", null, "any").to("f9"),
      map("x", null, "any").to("f10"),
      map("c", null, "any").to("f11"),
      map("v", null, "any").to("f12"),
    ],
    right: [
      map(KEYS.knobLeft, null, "any").to("volume_down"),
      map(KEYS.knobRight, null, "any").to("volume_up"),
    ],
  };
}

export function mk45Rules() {
  const layers = {
    default: defaultLayer(),
    lower: lowerLayer(),
    raise: raiseLayer(),
    media: mediaLayer(),
  };

  return [
    rule("mk23", ifDevice(DEVICES.mk23())).manipulators([
      withCondition(mk45Layers.ifActive("media"))(layers.media.left),
      withCondition(mk45Layers.ifActive("raise"))(layers.raise.left),
      withCondition(mk45Layers.ifActive("lower"))(layers.lower.left),
      ...layers.default.left,
    ]),
    rule("mk24", ifDevice(DEVICES.mk24())).manipulators([
      withCondition(mk45Layers.ifActive("media"))(layers.media.right),
      withCondition(mk45Layers.ifActive("raise"))(layers.raise.right),
      withCondition(mk45Layers.ifActive("lower"))(layers.lower.right),
      ...layers.default.right,
    ]),
  ];
}

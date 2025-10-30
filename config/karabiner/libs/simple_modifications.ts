import {
  FromEvent,
  FromKeyCode,
  toArray,
  ToEvent,
  toKey,
  ToKeyParam,
} from "./deps.ts";

export interface SimpleManipulator {
  from: FromEvent;
  to: ToEvent[];
}

export type SimpleModifications = SimpleManipulator[];

export function simpleModifications(
  manipulators: Partial<Record<FromKeyCode, ToKeyParam | ToEvent | ToEvent[]>>,
): SimpleModifications {
  return Object.entries(manipulators).map(([from, to]): SimpleManipulator => {
    return {
      from: { key_code: from as FromKeyCode },
      to: typeof to === "object" ? toArray(to) : [toKey(to)],
    };
  });
}

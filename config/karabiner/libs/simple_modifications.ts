import { BasicManipulatorBuilder, FromEvent, ToEvent } from "./deps.ts";

export interface SimpleManipulator {
  from: FromEvent;
  to?: ToEvent[];
}

export type SimpleModifications = SimpleManipulator[];

export function simpleModifications(
  builders: BasicManipulatorBuilder[],
): SimpleModifications {
  return builders
    .flatMap((builder) => builder.build())
    .map(({ type: _basic, ...m }) => m);
}

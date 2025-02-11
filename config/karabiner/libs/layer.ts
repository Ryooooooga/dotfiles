import { ifVar, toSetVar } from "./deps.ts";

export class Layers<const L extends string> {
  private readonly varName: string;
  private readonly map: Record<L, number>;

  constructor(varName: string, layerNames: ReadonlyArray<L>) {
    this.varName = varName;
    this.map = Object.fromEntries(
      layerNames.map((name, i) => [name, i]),
    ) as Record<L, number>;
  }

  toMO(layer: L) {
    return toSetVar(this.varName, this.map[layer], 0);
  }

  toTO(layer: L) {
    return toSetVar(this.varName, this.map[layer]);
  }

  ifActive(layer: L) {
    return ifVar(this.varName, this.map[layer]);
  }
}

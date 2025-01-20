import { ifVar, toSetVar } from "./deps.ts";

export class Layers<const V extends string, const L extends string> {
  private readonly varName: V;
  private readonly map: Record<L, number>;

  constructor(varName: V, layerNames: L[]) {
    this.varName = varName;
    this.map = Object.fromEntries(
      layerNames.map((name, i) => [name, i]),
    ) as Record<L, number>;
  }

  toMO(layer: L) {
    return toSetVar(this.varName, this.map[layer], 0);
  }

  ifActive(layer: L) {
    return ifVar(this.varName, this.map[layer]);
  }
}

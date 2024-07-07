export function throw_(err: unknown): never {
  throw err;
}

export function bgRed(s: string) {
  return `\x1b[41m${s}\x1b[m`;
}

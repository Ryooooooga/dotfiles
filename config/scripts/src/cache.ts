import { dirname } from "./deps.ts";

function homeDir(): string {
  return Deno.env.get("HOME") ?? "";
}

function xdgCacheHome(): string {
  return Deno.env.get("XDG_CACHE_HOME") ?? `${homeDir()}/.cache`;
}

export function cacheDir(): string {
  return `${xdgCacheHome()}/dotfiles`;
}

export async function withCache<T>(
  cacheFilePath: string,
  cacheTTL: number,
  format: "text" | "json",
  fn: () => Promise<T>,
): Promise<T> {
  const mtime = await Deno.stat(cacheFilePath)
    .then((stat) => stat.mtime)
    .catch(() => null);
  if (mtime !== null && mtime.getTime() + cacheTTL > Date.now()) {
    const cachedData = await Deno.readTextFile(cacheFilePath);
    switch (format) {
      case "text":
        return cachedData as unknown as T;
      case "json":
        return JSON.parse(cachedData);
      default:
        format satisfies never;
        throw new Error(`Unknown format: ${format}`);
    }
  }

  const data = await fn();

  await Deno.mkdir(dirname(cacheFilePath), { recursive: true });
  switch (format) {
    case "text":
      await Deno.writeTextFile(cacheFilePath, data as string);
      break;
    case "json":
      await Deno.writeTextFile(cacheFilePath, JSON.stringify(data));
      break;
  }

  return data;
}

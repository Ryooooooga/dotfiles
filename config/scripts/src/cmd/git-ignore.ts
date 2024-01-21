import { $, type Subprocess } from "bun";
import fs from "fs/promises";
import path from "path";
import os from "os";

type Entry = { fileName: string; contents: string; name: string; key: string };
type List = Record<string, Entry>;

const endpoint = "https://www.toptal.com/developers/gitignore/api";

const cacheDir = process.env.XDG_CACHE_HOME ?? `${os.homedir()}/.cache`;
const cacheFile = `${cacheDir}/dotfiles/gitignore.json`;
const cacheTTL = 1000 * 60 * 60 * 24;

async function loadIgnoreFromCache(): Promise<List | null> {
  const stat = await fs.stat(cacheFile).catch(() => null);
  if (stat === null || stat.mtimeMs < Date.now() - cacheTTL) {
    return null;
  }

  return JSON.parse(await fs.readFile(cacheFile, "utf-8"));
}

async function fetchIgnore(): Promise<List> {
  const list = await fetch(`${endpoint}/list?format=json`)
    .then((res) => res.json()) as List;

  await fs.mkdir(path.dirname(cacheFile), { recursive: true });
  await fs.writeFile(cacheFile, JSON.stringify(list), "utf-8");
  return list;
}

const list = await loadIgnoreFromCache() ?? await fetchIgnore();

const input = Object.values(list)
  .map(({ fileName, name, key }) => `${name} ${key} ${fileName}`)
  .sort()
  .join("\n");

const preview = `
  jq --arg key {2} -r '.[$key].contents' ${$.escape(cacheFile)} |
    bat --color=always --file-name={3} --language='Git Ignore'
`;

const result = await new Promise<Subprocess<"pipe", "pipe", "inherit">>(
  (resolve) => {
    const p = Bun.spawn({
      cmd: ["fzf", "--multi", "--with-nth=1", "--preview", preview],
      stdio: ["pipe", "pipe", "inherit"],
      onExit: () => {
        resolve(p);
      },
    });
    p.stdin.write(input);
    p.stdin.end();
  },
);

if (result.exitCode !== 0) {
  process.exit(1);
}

const keys = (await new Response(result.stdout).text())
  .trim()
  .split("\n")
  .map((line) => line.split(" ")[1]);

const contents = await fetch(`${endpoint}/${keys.join(",")}`);

if (process.stdout.isTTY) {
  await $`bat --color=always --paging=never --plain --language="Git Ignore" <${contents}`;
} else {
  process.stdout.write(await contents.text());
}

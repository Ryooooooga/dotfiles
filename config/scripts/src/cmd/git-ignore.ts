import { cacheDir } from "../cache.ts";
import { withCache } from "../cache.ts";
import { $ } from "../deps.ts";

const endpoint = "https://www.toptal.com/developers/gitignore/api";

type Ignore = {
  key: string;
  fileName: `${string}.gitignore`;
  name: string;
  contents: string;
};

async function fetchIgnoreList(): Promise<Record<string, Ignore>> {
  return await fetch(`${endpoint}/list?format=json`)
    .then((res) => res.json());
}

const cachePath = `${cacheDir()}/gitignore.json`;

const ignoreList = await withCache(
  cachePath,
  1000 * 60 * 60 * 24,
  "json",
  () => fetchIgnoreList(),
);

const lines = Object.values(ignoreList)
  .map(({ key, fileName, name }) => `${key} ${name} ${fileName}`)
  .sort();

const preview = String.raw`
  jq -r --arg key {1} '.[$key].contents' ${$.escapeArg(cachePath)} |
    bat --color=always --file-name={3} --language='Git Ignore'
`;

const { stdout } = await $`fzf --multi --with-nth=2 --preview=${preview}`
  .stdout("piped")
  .stdinText(lines.join("\n"))
  .noThrow();

const keys = stdout
  .split("\n")
  .filter((line) => line.length > 0)
  .map((line) => line.split(" ")[0]);

if (keys.length === 0) {
  Deno.exit(1);
}

const res = await fetch(`${endpoint}/${keys.join(",")}`);

await $`bat --paging=never --plain --language='Git Ignore'`
  .stdin(res.body ?? "null");

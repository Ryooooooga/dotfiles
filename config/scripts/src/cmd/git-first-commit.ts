import { $ } from "../deps.ts";

if ((await $`git rev-parse`.noThrow()).code !== 0) {
  Deno.exit(1);
}

if ((await $`git rev-parse HEAD`.quiet().noThrow()).code === 0) {
  console.error("this is not an empty repository");
  Deno.exit(1);
}

const message = Deno.args[0] ?? "initial commit";
await $`git commit -m ${message} --allow-empty`;

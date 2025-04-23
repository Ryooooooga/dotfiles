#!/usr/bin/env -S deno run -A
import { $ } from "jsr:@david/dax";

if ((await $`git rev-parse`.noThrow()).code !== 0) {
  Deno.exit(1);
}

if ((await $`git rev-parse HEAD`.noThrow().quiet()).code === 0) {
  console.error("this is not an empty repository");
  Deno.exit(1);
}

const message = "initial commit";
await $`git commit -m ${message} --allow-empty`;

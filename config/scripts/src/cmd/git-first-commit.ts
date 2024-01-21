import { $ } from "bun";

const message = process.argv[2] ?? "initial commit";

if ((await $`git rev-parse`).exitCode !== 0) {
  process.exit(1);
}

if ((await $`git rev-parse HEAD`.quiet()).exitCode === 0) {
  console.error("this is not an empty repository");
  process.exit(1);
}

if ((await $`git commit -m ${message} --allow-empty`).exitCode !== 0) {
  process.exit(1);
}

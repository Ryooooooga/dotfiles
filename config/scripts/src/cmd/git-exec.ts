import { $ } from "bun";

const args = process.argv.slice(2);

if (args.length === 0) {
  console.error("Usage: git-exec <CMD>...");
  process.exit(1);
}

if ((await $`git diff --shortstat --exit-code --quiet`).exitCode !== 0) {
  console.error("repository is dirty...");
  process.exit(1);
}

if (
  (await $`git diff --shortstat --exit-code --quiet --staged`).exitCode !== 0
) {
  console.error("changes are not committed yet...");
  process.exit(1);
}

const cmd = args.map((arg) => $.escape(arg)).join(" ");

if (
  Bun.spawnSync({
    cmd: args,
    stdio: ["inherit", "inherit", "inherit"],
  }).exitCode !== 0
) {
  console.error(`command \`${cmd}\` failed...`);
  process.exit(1);
}

const message = `$ ${cmd}`;

if (
  (await $`git add -A && git commit -m ${message}`).exitCode !== 0
) {
  process.exit(1);
}

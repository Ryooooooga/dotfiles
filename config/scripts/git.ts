import { $, CommandResult } from "./deps.ts";

export async function getConfig(key: string): Promise<string | undefined> {
  return await $`git config ${key}`.text().catch(() => undefined);
}

export async function getConfigRegex(regex: string): Promise<string[]> {
  return await $`git config --get-regex ${regex}`.lines();
}

export async function setConfig(
  key: string,
  value: string
): Promise<CommandResult> {
  return await $`git config ${key} ${value}`.noThrow();
}

export async function unsetConfig(key: string): Promise<CommandResult> {
  return await $`git config --unset ${key}`.noThrow();
}

export async function getLastCommitter(): Promise<{
  name: string;
  email: string;
}> {
  const output =
    await $`git --no-pager show --quiet --pretty='format:%cn%x00%ce'`
      .stderr("null")
      .text();

  const [name, email] = output.split("\0");
  return { name, email };
}

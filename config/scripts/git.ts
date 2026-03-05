import { $ } from "@david/dax";

export async function getConfig(key: string): Promise<string | undefined> {
  return await $`git config get ${key}`.text().catch(() => undefined);
}

export async function getConfigRegex(regex: string): Promise<string[]> {
  return await $`git config get --all --show-names --regex ${regex}`.lines();
}

export async function setConfig(key: string, value: string): Promise<void> {
  await $`git config set ${key} ${value}`.noThrow();
}

export async function unsetConfig(key: string): Promise<void> {
  await $`git config unset ${key}`.noThrow();
}

export async function getLastCommitter(): Promise<
  { name: string; email: string } | undefined
> {
  const output =
    await $`git --no-pager show --quiet --pretty='format:%cn%x00%ce'`
      .stderr("null")
      .text();

  if (output.length === 0) {
    return undefined;
  }

  const [name, email] = output.split("\0");
  return { name, email };
}

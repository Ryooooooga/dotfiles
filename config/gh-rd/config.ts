import { defineConfig } from "https://raw.githubusercontent.com/Ryooooooga/gh-rd/main/src/config/types.ts";

async function saveCommandOutput(
  cmd: [string, ...string[]],
  to: string,
) {
  const { stdout } = await new Deno.Command(cmd[0], {
    args: cmd.slice(1),
    stderr: "inherit",
  }).output();

  await Deno.writeFile(to, stdout);
}

async function saveRemoteFile(
  from: string,
  to: string,
) {
  const res = await fetch(new URL(from));
  if (res.body !== null) {
    await Deno.writeFile(to, res.body);
  }
}

export default defineConfig({
  tools: [
    {
      name: "rossmacarthur/sheldon",
    },
    {
      name: "Ryooooooga/croque",
      async onDownload({ packageDir, bin: { croque } }) {
        await saveCommandOutput(
          [croque, "init", "zsh"],
          `${packageDir}/croque.zsh`,
        );
      },
    },
    {
      name: "Ryooooooga/zabrze",
      async onDownload({ packageDir, bin: { zabrze } }) {
        await saveCommandOutput(
          [zabrze, "init", "--bind-keys"],
          `${packageDir}/zabrze.zsh`,
        );
      },
    },
    {
      name: "Ryooooooga/qwy",
      async onDownload({ packageDir, bin: { qwy } }) {
        await saveCommandOutput(
          [qwy, "init"],
          `${packageDir}/qwy.zsh`,
        );
      },
    },
    {
      name: "Ryooooooga/zouch",
    },
    {
      name: "Ryooooooga/monkeywrench",
    },
    {
      name: "direnv/direnv",
      rename: [
        { from: "direnv*", to: "direnv", chmod: 0o755 },
      ],
      async onDownload({ packageDir, bin: { direnv } }) {
        await saveCommandOutput(
          [direnv, "hook", "zsh"],
          `${packageDir}/direnv.zsh`,
        );
      },
    },
    {
      name: "dandavison/delta",
    },
    {
      name: "itchyny/mmv",
    },
    {
      name: "BurntSushi/ripgrep",
    },
    {
      name: "x-motemen/ghq",
    },
    {
      name: "jesseduffield/lazygit",
    },
    {
      name: "cli/cli",
      async onDownload({ packageDir, bin: { gh } }) {
        await saveCommandOutput(
          [gh, "completion", "--shell", "zsh"],
          `${packageDir}/_gh`,
        );
      },
    },
    {
      name: "eza-community/eza",
      enabled: Deno.build.os !== "darwin",
      async onDownload({ packageDir }) {
        await saveRemoteFile(
          "https://raw.githubusercontent.com/eza-community/eza/main/completions/zsh/_eza",
          `${packageDir}/_eza`,
        );
      },
    },
    {
      name: "mikefarah/yq",
      rename: [
        { from: "yq_*", to: "yq", chmod: 0o755 },
      ],
      async onDownload({ packageDir, bin: { yq } }) {
        await saveCommandOutput(
          [yq, "shell-completion", "zsh"],
          `${packageDir}/_yq`,
        );
      },
    },
    {
      name: "rhysd/hgrep",
      async onDownload({ packageDir, bin: { hgrep } }) {
        await saveCommandOutput(
          [hgrep, "--generate-completion-script", "zsh"],
          `${packageDir}/_hgrep`,
        );
      },
    },
    {
      name: "denisidoro/navi",
    },
    {
      name: "dbrgn/tealdeer",
      rename: [
        { from: "tealdeer*", to: "tldr", chmod: 0o755 },
      ],
      async onDownload({ packageDir }) {
        await saveRemoteFile(
          "https://github.com/dbrgn/tealdeer/releases/latest/download/completions_zsh",
          `${packageDir}/_tldr`,
        );
      },
    },
    {
      name: "himanoa/mdmg",
      executables: [
        { glob: "**/mdmg" },
      ],
      async onDownload({ packageDir }) {
        await saveRemoteFile(
          "https://raw.githubusercontent.com/Ryooooooga/mdmg/master/completions/mdmg.completion.zsh",
          `${packageDir}/_mdmg`,
        );
      },
    },
    {
      name: "junegunn/fzf",
      async onDownload({ packageDir }) {
        await saveRemoteFile(
          "https://raw.githubusercontent.com/junegunn/fzf/master/shell/completion.zsh",
          `${packageDir}/_fzf`,
        );
      },
    },
    {
      name: "sharkdp/bat",
    },
    {
      name: "sharkdp/fd",
    },
    {
      name: "sharkdp/hexyl",
    },
    {
      name: "XAMPPRocky/tokei",
    },
    {
      name: "neovim/neovim",
      enabled: Deno.build.arch === "x86_64",
    },
    {
      name: "equalsraf/win32yank",
      enabled: Deno.env.has("WSLENV") && Deno.build.arch === "x86_64",
      use: `win32yank-x64*`,
    },
  ],
});

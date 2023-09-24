import { defineConfig } from "https://raw.githubusercontent.com/Ryooooooga/gh-rd/main/src/config.ts";

async function saveCommandOutput(
  to: string,
  cmd: string,
  ...args: string[]
) {
  const { stdout } = await new Deno.Command(cmd, {
    args,
    stderr: "inherit",
  }).output();

  await Deno.writeFile(to, stdout);
}

async function saveRemoteFile(
  to: string,
  from: string,
) {
  const res = await fetch(new URL(from));
  if (res.body !== null) {
    await Deno.writeFile(to, res.body);
  }
}

export default defineConfig({
  tools: [
    {
      name: "direnv/direnv",
      rename: [
        { from: "direnv*", to: "direnv" },
      ],
    },
    {
      name: "Ryooooooga/zabrze",
    },
    {
      name: "dandavison/delta",
    },
    {
      name: "itchyny/mmv",
    },
    {
      name: "BurntSushi/ripgrep",
      executables: [
        { glob: "**/rg", as: "rg" },
      ],
    },
    {
      name: "x-motemen/ghq",
    },
    {
      name: "jesseduffield/lazygit",
    },
    {
      name: "Ryooooooga/zouch",
    },
    {
      name: "Ryooooooga/monkeywrench",
    },
    {
      name: "cli/cli",
      executables: [
        { glob: "**/gh", as: "gh" },
      ],
      async onDownload({ packageDir, bin }) {
        await saveCommandOutput(
          `${packageDir}/_gh`,
          bin.gh,
          "completion",
          "--shell",
          "zsh",
        );
      },
    },
    {
      name: "eza-community/eza",
      async onDownload({ packageDir }) {
        await saveRemoteFile(
          `${packageDir}/_eza`,
          "https://raw.githubusercontent.com/eza-community/eza/main/completions/zsh/_eza",
        );
      },
    },
    {
      name: "mikefarah/yq",
      rename: [
        { from: "yq_*", to: "yq" },
      ],
      async onDownload({ packageDir, bin }) {
        await saveCommandOutput(
          `${packageDir}/_yq`,
          bin.yq,
          "shell-completion",
          "zsh",
        );
      },
    },
    {
      name: "rhysd/hgrep",
      async onDownload({ packageDir, bin }) {
        await saveCommandOutput(
          `${packageDir}/_hgrep`,
          bin.hgrep,
          "--generate-completion-script",
          "zsh",
        );
      },
    },
    {
      name: "denisidoro/navi",
    },
    {
      name: "Ryooooooga/qwy",
    },
    {
      name: "dbrgn/tealdeer",
      rename: [
        { from: "tealdeer*", to: "tldr" },
      ],
      executables: [
        { glob: "tldr", as: "tldr" },
      ],
      async onDownload({ packageDir }) {
        await saveRemoteFile(
          `${packageDir}/_tldr`,
          "https://github.com/dbrgn/tealdeer/releases/latest/download/completions_zsh",
        );
      },
    },
    {
      name: "himanoa/mdmg",
      async onDownload({ packageDir }) {
        await saveRemoteFile(
          `${packageDir}/_mdmg`,
          "https://raw.githubusercontent.com/Ryooooooga/mdmg/master/completions/mdmg.completion.zsh",
        );
      },
    },
    {
      name: "Ryooooooga/croque",
    },
    {
      name: "junegunn/fzf",
      async onDownload({ packageDir }) {
        await saveRemoteFile(
          `${packageDir}/_fzf`,
          "https://raw.githubusercontent.com/junegunn/fzf/master/shell/completion.zsh",
        );
      },
    },
    {
      name: "sharkdp/fd",
    },
    {
      name: "XAMPPRocky/tokei",
    },
    {
      name: "neovim/neovim",
      executables: [
        { glob: "**/nvim", as: "nvim" },
      ],
    },
  ],
});

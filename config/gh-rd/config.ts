import { defineConfig } from "https://deno.land/x/gh_rd/mod.ts";

export default defineConfig({
  tools: [
    {
      name: "rossmacarthur/sheldon",
    },
    {
      name: "Ryooooooga/croque",
      async onDownload({ bin: { croque }, $ }) {
        await $`${croque} init zsh >croque.zsh`;
      },
    },
    {
      name: "Ryooooooga/zabrze",
      async onDownload({ bin: { zabrze }, $ }) {
        await $`${zabrze} init --bind-keys >zabrze.zsh`;
      },
    },
    {
      name: "Ryooooooga/qwy",
      async onDownload({ bin: { qwy }, $ }) {
        await $`${qwy} init >qwy.zsh`;
      },
    },
    {
      name: "Ryooooooga/zouch",
    },
    {
      name: "Ryooooooga/monkeywrench",
    },
    {
      name: "jdx/mise",
      async onDownload({ bin: { mise }, $ }) {
        await Promise.all([
          $`${mise} completion zsh >_mise`,
          $`${mise} activate zsh >mise.zsh`,
        ]);
      },
    },
    {
      name: "direnv/direnv",
      rename: [
        { from: "direnv*", to: "direnv", chmod: 0o755 },
      ],
      async onDownload({ bin: { direnv }, $ }) {
        await $`${direnv} hook zsh >direnv.zsh`;
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
      async onDownload({ bin: { gh }, $ }) {
        await $`${gh} completion --shell zsh >_gh`;
      },
    },
    {
      name: "eza-community/eza",
      enabled: Deno.build.os !== "darwin",
      async onDownload({ packageDir, $ }) {
        await $.request(
          "https://raw.githubusercontent.com/eza-community/eza/main/completions/zsh/_eza",
        ).pipeToPath(`${packageDir}/_eza`);
      },
    },
    {
      name: "mikefarah/yq",
      rename: [
        { from: "yq_*", to: "yq", chmod: 0o755 },
      ],
      async onDownload({ bin: { yq }, $ }) {
        await $`${yq} shell-completion zsh >_yq`;
      },
    },
    {
      name: "rhysd/hgrep",
      async onDownload({ bin: { hgrep }, $ }) {
        await $`${hgrep} --generate-completion-script zsh >_hgrep`;
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
      async onDownload({ packageDir, bin: { tldr }, $ }) {
        await Promise.all([
          $`${tldr} --update`,

          $.request(
            "https://github.com/dbrgn/tealdeer/releases/latest/download/completions_zsh",
          ).pipeToPath(`${packageDir}/_tldr`),
        ]);
      },
    },
    {
      name: "junegunn/fzf",
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
    {
      name: "ldc-developers/ldc",
      executables: [
        { glob: "**/bin/{dub,ldc2,rdmd}" },
      ],
    },
  ],
});

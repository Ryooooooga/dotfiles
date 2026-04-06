#!/bin/sh -e
ubuntu_version="$(lsb_release -r | awk '{print $2 * 100}')"

apt-get update
apt-get upgrade -y
apt-get install -y \
  autoconf \
  build-essential \
  clang \
  clangd \
  clang-format \
  cmake \
  git \
  git-lfs \
  gpg \
  jq \
  libfuse-dev \
  libsqlite3-dev \
  libssl-dev \
  python3 \
  python3-pip \
  python3-pynvim \
  shellcheck \
  sqlite3 \
  tmux \
  trash-cli \
  unzip \
  wget \
  zip \
  zsh

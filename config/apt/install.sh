#!/bin/sh -e
ubuntu_version="$(lsb_release -r | awk '{print $2 * 100}')"

add-apt-repository -y ppa:git-core/ppa
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

# Docker
curl -fsSL 'https://download.docker.com/linux/ubuntu/gpg' | apt-key add -
add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update
apt-get install -y docker-ce docker-ce-cli

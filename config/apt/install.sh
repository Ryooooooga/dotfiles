#!/bin/sh
ubuntu_version="$(lsb_release -r | awk '{print $2 * 100}')"

add-apt-repository -y ppa:git-core/ppa &&
apt-get update && apt-get upgrade -y &&
apt-get install -y \
    autoconf \
    automake \
    build-essential \
    cmake \
    colordiff \
    git \
    gpg \
    jq \
    libssl-dev \
    neovim \
    python3 \
    python3-pip \
    tmux \
    unzip \
    wget \
    zip \
    zsh &&
if [ "$ubuntu_version" -ge 2004 ]; then
    # Ubuntu 20.04 or later
    apt-get install -y fd-find
fi

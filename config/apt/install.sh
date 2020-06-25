#!/bin/sh
add-apt-repository -y ppa:git-core/ppa &&
apt-get update && apt-get upgrade -y &&
apt-get install -y \
    autoconf \
    automake \
    build-essential \
    cmake \
    colordiff \
    docker.io \
    fd-find \
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
    zsh

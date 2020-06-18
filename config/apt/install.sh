#!/bin/sh
add-apt-repository ppa:git-core/ppa &&
apt-get update && apt-get upgrade &&
apt-get install -y \
    automake \
    build-essential \
    colordiff \
    docker.io \
    git \
    gpg \
    hub \
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

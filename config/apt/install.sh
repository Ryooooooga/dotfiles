#!/bin/sh
ubuntu_version="$(lsb_release -r | awk '{print $2 * 100}')"

add-apt-repository -y ppa:git-core/ppa &&
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key C99B11DEB97541F0 &&
apt-add-repository https://cli.github.com/packages &&
apt-get update && apt-get upgrade -y &&
apt-get install -y \
    autoconf \
    automake \
    build-essential \
    clang \
    clang-format \
    cmake \
    colordiff \
    gh \
    git \
    gpg \
    hub \
    jq \
    libsqlite3-dev \
    libssl-dev \
    neovim \
    python3 \
    python3-pip \
    sqlite3 \
    tmux \
    unzip \
    wget \
    zip \
    zsh

if [ $? -ne 0 ]; then
    exit 1
fi

if [ "$ubuntu_version" -ge 2004 ]; then
    # Ubuntu 20.04 or later
    apt-get install -y \
        clangd \
        fd-find \
        python3-pynvim

    if [ $? -ne 0 ]; then
        exit 1
    fi
fi

curl -fsSL 'https://download.docker.com/linux/ubuntu/gpg' | apt-key add - &&
add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" &&
apt-get update &&
apt-get install -y docker-ce docker-ce-cli

if [ $? -ne 0 ]; then
    exit 1
fi

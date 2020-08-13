#!/bin/sh
ubuntu_version="$(lsb_release -r | awk '{print $2 * 100}')"

curl -fsSL 'https://download.docker.com/linux/ubuntu/gpg' | apt-key add -

add-apt-repository -y ppa:git-core/ppa &&
add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" &&
apt-get update && apt-get upgrade -y &&
apt-get install -y \
    autoconf \
    automake \
    build-essential \
    cmake \
    colordiff \
    docker-ce \
    docker-ce-cli \
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

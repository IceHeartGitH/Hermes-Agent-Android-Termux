#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

pkg update -y
pkg upgrade -y
pkg install -y \
  bash coreutils termux-tools \
  curl git \
  python python-pip python-cryptography python-psutil \
  nodejs npm \
  clang make rust pkg-config libffi openssl ca-certificates \
  libxml2 libxslt python-lxml \
  ripgrep openssh \
  jq fd wget \
  unzip tar

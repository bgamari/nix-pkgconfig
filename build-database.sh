#!/usr/bin/env bash

set -e

if [[ ! -e "$HOME/.cache/nix-index" ]]; then
  echo "nix-index database doesn't exist. Creating..."
  nix run nixpkgs.nix-index nixpkgs.python3 -c \
    python3 ./build-pc-index.py
fi

echo "building pkg-config database..."
nix run nixpkgs.nix-index nixpkgs.python3 -c \
  python3 ./build-pc-index.py -o database.json

echo "installing database..."
mkdir -p $HOME/.config/nix-pkgconfig
mv database.json $HOME/.config/nix-pkgconfig
echo "done."

#!/usr/bin/env bash

set -e

if [[ ! -e "$HOME/.cache/nix-index" ]]; then
  echo "nix-index database doesn't exist. Creating..."
  nix run nixpkgs.nix-index -c nix-index
fi

echo "building pkg-config database..."
nix run nixpkgs.nix-index nixpkgs.python3 -c \
  python3 ./build-pc-index.py -o database.json

echo "installing database..."
dest=$HOME/.config/nix-pkgconfig
mkdir -p $dest
cp default-database.json $dest/001-default.json
mv database.json $dest/002-nixpkgs.json
echo "done."

#!/usr/bin/env bash

set -e

if [[ "$1" == "--help" ]]; then
  cat <<EOF
Usage: $0 [--help] [--update]

Builds a database of nix derivations and their provided .pc files for
nix-pkgconfig

    --update   Force update of nix-locate database
    --help     Show this usage message
EOF
  exit 0
fi

if [[ -z "$XDG_CACHE_HOME" ]]; then
  XDG_CACHE_HOME="$HOME/.cache"
fi

if [[ -z "$XDG_CONFIG_HOME" ]]; then
  XDG_CONFIG_HOME="$HOME/.config"
fi

if [[ ! -e "$XDG_CACHE_HOME/nix-index" ]] || [[ "$1" == "--update" ]]; then
  echo "nix-index database doesn't exist. Creating..."
  nix run nixpkgs.nix-index -c nix-index
fi

echo "building pkg-config database..."
nix run nixpkgs.nix-index nixpkgs.python3 -c \
  python3 ./build-pc-index.py -o database.json

echo "installing database..."
dest=$XDG_CONFIG_HOME/nix-pkgconfig
mkdir -p $dest
cp default-database.json $dest/001-default.json
mv database.json $dest/002-nixpkgs.json
echo "done."

#!/usr/bin/env bash

set -e

nix run nixpkgs.nix-index -c nix-index
nix run nixpkgs.nix-index -c nix-locate *.pc

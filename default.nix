{ nixpkgs ? (import <nixpkgs> {}) }:

nixpkgs.callPackage ./package.nix {}

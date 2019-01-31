{ nixpkgs ? (import <nixpkgs> {}) }:

with nixpkgs;
let 
  nix-pkgconfig = callPackage ./package.nix {};
in nix-pkgconfig

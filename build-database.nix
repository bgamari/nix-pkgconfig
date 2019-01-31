{ nixpkgs ? (import <nixpkgs> {}), pkg-index }:

with nixpkgs;
let
  /** Unfortunately nix-index requires internet access so this won't work.

  pkg-index = runCommand "nix-index-database" {
    buildInputs = [ nix nix-index ];
  } ''
    mkdir -p $out
    echo ${nixpkgs.path}
    export NIX_STATE_DIR=`pwd`/tmp
    nix-index -d $out -f ${nixpkgs.path}
  '';
    */

  pc-database = runCommand "pkgconfig-database" {
    nativeBuildInputs = [ nix-index python3 ];
  } ''
    mkdir -p $out
    python3 ${./build-pc-index.py} -d ${pkg-index} -o $out/database.json
  '';
in pc-database

{ nixpkgs ? (import <nixpkgs> {}), pkg-index ? null }:

with nixpkgs;
let 
  nix-pkgconfig = callPackage ./package.nix {};

  # This currently isn't used since it's quite inconvient due to nix-index's
  # dependence on Internet access.
  pc-database = import ./build-database.nix { inherit nixpkgs pkg-index; };
  wrapped = runCommand "nix-pkgconfig-wrapped" {
    nativeBuildInputs = [ makeWrapper ];
    passthru = { inherit database; };
  } ''
    mkdir -p $out/bin
    makeWrapper ${nix-pkgconfig}/bin/pkg-config $out/bin/pkg-config \
      --suffix NIX_PKGCONFIG_DATABASES : ${./default-database.json}:${pc-database}/database.json
  '';
in nix-pkgconfig

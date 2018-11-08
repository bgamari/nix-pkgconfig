{ stdenv, pkgconfig, python3 }:

stdenv.mkDerivation {
  name = "nixpkgs-pkgconfig";
  buildInputs = [ python3 ];
  src = ./.;
  installPhase = ''
    mkdir -p $out/bin
    cp pkg-config $out/bin/pkg-config
  '';
}

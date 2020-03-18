{ pkgs ? import (import ./nix/sources.nix).nixpkgs }:
with pkgs;

assert lib.versionAtLeast go.version "1.13";

buildGoPackage rec {
  name = "christinewebsite-HEAD";
  version = "latest";
  goPackagePath = "christine.website";
  src = ./.;
  goDeps = ./nix/deps.nix;
  allowGoReference = false;

  preBuild = ''
    export CGO_ENABLED=0
    buildFlagsArray+=(-pkgdir "$TMPDIR")
  '';

  postInstall = ''
    cp -rf $src/blog $bin/blog
    cp -rf $src/css $bin/css
    cp -rf $src/gallery $bin/gallery
    cp -rf $src/signalboost.dhall $bin/signalboost.dhall
    cp -rf $src/static $bin/static
    cp -rf $src/talks $bin/talks
    cp -rf $src/templates $bin/templates
  '';
}

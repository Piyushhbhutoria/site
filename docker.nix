{ system ? builtins.currentSystem }:

let
  pkgs = import (import ./nix/sources.nix).nixpkgs { inherit system; };
  callPackage = pkgs.lib.callPackageWith pkgs;
  site = callPackage ./site.nix { };

  dockerImage = pkg:
    pkgs.dockerTools.buildLayeredImage {
      name = "xena/christinewebsite";
      tag = pkg.version;

      contents = [ pkg ];

      config = {
        Cmd = [ "/bin/site" ];
        WorkingDir = "/";
      };
    };

in dockerImage site

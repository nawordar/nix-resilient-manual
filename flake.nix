{
  inputs = {
    nixpkgs.url = "github:nawordar/nixpkgs/add-resilient-sile";
    flake-utils.url = "github:numtide/flake-utils";
    resilient-sile = {
      url = "github:Omikhleia/resilient.sile";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    resilient-sile,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        lib = nixpkgs.lib;
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfreePredicate = pkg:
            builtins.elem (lib.getName pkg) ["symbola"];
          overlays = [(import ./nix/overlay.nix)];
        };

        FONTCONFIG_FILE = pkgs.makeFontsConf {
          fontDirectories = with pkgs; [
            hack-font
            libertinus
            symbola
          ];
        };

        manual = pkgs.stdenv.mkDerivation {
          name = "manual";
          src = resilient-sile;

          inherit FONTCONFIG_FILE;
          buildInputs = with pkgs; [graphviz lilypond sile];

          buildPhase = ''
            sile -u inputters.silm examples/sile-resilient-manual.silm
          '';

          installPhase = ''
            mkdir -p $out
            cp examples/sile-resilient-manual.pdf $out
          '';
        };
      in {
        packages = {
          default = manual;
          manual = manual;
        };

        formatter = pkgs.alejandra;
      }
    );
}

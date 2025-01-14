{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf mkOption;
  cfg = config.${namespace}.core.nix;
in
{
  options.${namespace}.core.nix = {
    enable = mkEnableOption "Nix";
    nixLd = mkOption {
      type = lib.types.submodule {
        options = {
          enable = mkEnableOption "Enable nix-ld";
          libraries = mkOption {
            type = lib.types.listOf lib.types.package;
            default = [ ];
            description = "Additional libraries to link against.";
          };
        };
      };
      default = { };
      description = "Nix-LD is a library for loading Nix expressions at runtime.";
    };
  };

  config = mkIf cfg.enable {
    programs.nix-ld = {
      inherit (cfg.nixLd) enable;
      libraries =
        with pkgs;
        [
          gcc
          icu
          libcxx
          stdenv.cc.cc.lib
          zlib
        ]
        ++ (if cfg.nixLd.libraries != null then cfg.nixLd.libraries else [ ]);
    };
    environment.systemPackages = with pkgs; [
      statix
      deadnix
      nixfmt-rfc-style
      nixpkgs-fmt
      nixd
      nix-prefetch-github
    ];
    nix = {
      settings.experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };
}

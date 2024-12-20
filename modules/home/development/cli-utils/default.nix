{ config
, pkgs
, lib
, ...
}:

let
  inherit (lib) mkEnableOption mkIf;

  devCfg = config.cirius.development;
  cfg = devCfg.cli-utils;
in
{
  options.cirius.development.cli-utils = {
    enable = mkEnableOption "CLI Utilities";
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        jq
        atuin
        fzf
        ripgrep
        tree-sitter
        unzip
        gcc
        gnumake
        go-task
        wget
        curl
        libglvnd
        air
        btop
        gnused
        thefuck
      ];
    };

    programs = {
      direnv = {
        inherit (cfg) enable;
        nix-direnv = {
          enable = true;
        };
      };
    };
  };
}

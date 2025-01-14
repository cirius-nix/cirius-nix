{
  config,
  pkgs,
  lib,
  namespace,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;

  devCfg = config.${namespace}.development;
  cfg = devCfg.cli-utils;
in
{
  options.${namespace}.development.cli-utils = {
    enable = mkEnableOption "CLI Utilities";
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        jq
        atuin
        fzf
        yazi
        ripgrep
        tree-sitter
        unzip
        gcc
        gnumake
        go-task
        wget
        curl
        libglvnd
        btop
        gnused
        thefuck
        bat
        zip
        unzip
        fastfetch
      ];
      shellAliases = {
        la = lib.mkForce "${lib.getExe config.programs.eza.package} -lah --tree";
        tree = lib.mkForce "${lib.getExe config.programs.eza.package} --tree --icons=always";
      };
    };

    programs = {
      eza = {
        enable = true;
        enableBashIntegration = true;
        enableZshIntegration = true;
        enableNushellIntegration = true;
        enableFishIntegration = true;
        extraOptions = [
          "--group-directories-first"
          "--header"
        ];
        git = true;
        icons = "auto";
      };
      direnv = {
        enable = true;
        nix-direnv = {
          enable = true;
        };
      };
    };
  };
}

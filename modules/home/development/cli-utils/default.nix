{
  config,
  pkgs,
  lib,
  ...
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
        # glxinfo
        go-swagger
        air # live reload for Go apps
        air
        btop
        gnused
        thefuck
        sshpass
        bat
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

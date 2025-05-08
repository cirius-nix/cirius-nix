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
    ${namespace}.development.cli-utils.fish = {
      interactiveCommands = [
      ];
    };
    home = {
      packages = with pkgs; [
        jq
        fzf
        ripgrep
        tree-sitter
        gcc
        gnumake
        go-task
        wget
        curl
        libglvnd
        btop
        gnused
        zip
        unzip
      ];
      shellAliases = {
        la = lib.mkForce "${lib.getExe config.programs.eza.package} -lah --tree";
        tree = lib.mkForce "${lib.getExe config.programs.eza.package} --tree --icons=always";
      };
    };
    programs = {
      atuin = {
        enable = true;
        daemon.enable = true;
        enableFishIntegration = true;
        settings = {
          auto_sync = true;
          sync_frequency = "5m";
          style = "compact"; # compact | full | auto
          # Use CTRL-R to switch between modes.
          # global (default)	Search history from all hosts, all sessions, all directories
          # host	Search history just from this host
          # session	Search history just from the current session
          # directory	Search history just from the current directory
          # workspace	Search history just from the current git repository (>17.0)
          filter_mode = "workspace";
          filter_mode_shell_up_key_binding = "workspace";
          workspaces = true;
          secret_filter = true;
        };
      };
      thefuck = {
        enable = true;
        enableFishIntegration = true;
      };
      bat = {
        enable = true;
        config = {
          italic-text = "always";
          map-syntax = [
            "*.ino:C++"
            ".ignore:Git Ignore"
          ];
          pager = "less --RAW-CONTROL-CHARS --mouse";
          theme = "TwoDark";
        };
      };
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

    ${namespace}.development.ide.vscode.addPlugins = with pkgs.vscode-extensions; [
      mikestead.dotenv
      mkhl.direnv
    ];
  };
}

{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf generators;
  inherit (lib.${namespace}) mergeL';
  cfg = config.${namespace}.development.term.konsole;

in
{
  options.${namespace}.development.term.konsole = {
    enable = mkEnableOption "Enable konsole terminal";
    profile = lib.mkOption {
      type = with lib.types; nullOr attrs;
      description = "Attrset of profile";
      default = null;
    };
    settings = lib.mkOption {
      type = with lib.types; nullOr attrs;
      description = "Attrset of settings";
      default = null;
    };
  };

  config = mkIf (cfg.enable && pkgs.stdenv.isLinux) {
    home.packages = with pkgs; [
      kdePackages.konsole
    ];
    home.file = {
      ".config/konsolerc".text = generators.toINI { } (
        mergeL'
          {
            "Desktop Entry" = {
              "DefaultProfile" = "${config.${namespace}.user.username}.profile";
            };
            "General" = {
              "ConfigVersion" = "1";
            };
            "KonsoleWindow" = {
              "AllowMenuAccelerators" = "true";
            };
            "Notification Messages" = {
              "CloseSingleTab" = "true";
            };
            "TabBar" = {
              "ExpandTabWidth" = "true";
              "NewTabButton" = "true";
              "TabBarPosition" = "Bottom";
            };
          }
          [
            cfg.settings
          ]
      );
      ".local/share/konsole/${config.${namespace}.user.username}.profile".text = generators.toINI { } (
        mergeL'
          {
            General = {
              Name = config.${namespace}.user.username;
              Command = "${pkgs.fish}/bin/fish";
              Parent = "FALLBACK/";
              TerminalCenter = true;
              TerminalMargin = 0;
            };
            Appearance = {
              LineSpacing = 0;
            };
            Keyboard = {
              KeyBindings = "default";
            };
          }
          [
            cfg.profile
          ]
      );
    };
  };
}

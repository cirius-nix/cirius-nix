{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;
  deCfg = config.${namespace}.desktop-environment;
  hyprCfg = deCfg.hyprland;
  cfg = hyprCfg.launchpad;
  enabled = deCfg.kind == "hyprland" && pkgs.stdenv.isLinux && cfg.enable;
in

{
  options.${namespace}.desktop-environment.hyprland.launchpad = {
    enable = mkBoolOpt true "Whether to enable the Launchpad in the desktop environment.";
  };
  config = mkIf enabled {
    wayland.windowManager.hyprland = {
      settings = {
        windowrulev2 = [
          "float, class:Rofi"
          "stayfocused, class:Rofi"
        ];
      };
    };

    programs.rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
      font = "MonaspiceNe Nerd Font 14";
      location = "center";
      theme = hyprCfg.theme;
      pass = {
        enable = true;
        package = pkgs.rofi-pass-wayland;
      };
      plugins = with pkgs; [
        rofi-calc
        rofi-emoji
        rofi-top
      ];
    };
    xdg.configFile = {
      "rofi/config.rasi".text = import ./config.nix {
        inherit (hyprCfg) theme;
      };
      "rofi/${hyprCfg.theme}.rasi".text =
        let
          activatedTheme = hyprCfg.themes.activatedTheme;
          colors = activatedTheme.colors;
        in
        ''
          * {
            ${hyprCfg.themes.standardColorVars}
            bg-col:  ${colors.base.rgb};
            bg-col-light: ${colors.crust.rgb};
            border-col: ${colors.text.rgb};
            selected-col: ${colors.mantle.rgb};
            fg-col: ${colors.text.rgb};
            fg-col2: ${colors.textAlt.rgb};
            width: 600;
          }
        '';
    };
  };
}

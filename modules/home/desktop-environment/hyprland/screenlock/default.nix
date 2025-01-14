{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  deCfg = config.${namespace}.desktop-environment;
  hyprCfg = deCfg.hyprland;
  cfg = hyprCfg.screenlock;
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;
  inherit (hyprCfg.themes) combinedColors;

  enabled = pkgs.stdenv.isLinux && deCfg.kind == "hyprland" && cfg.enable;
in
{
  options.${namespace}.desktop-environment.hyprland.screenlock = {
    enable = mkBoolOpt false "Whether to enable hyprlock in the desktop environment.";
  };

  config = mkIf enabled {
    programs.swaylock = {
      enable = true;
      package = pkgs.swaylock-effects; # use effects variant.
      settings = {
        ignore-empty-password = true;
        disable-caps-lock-text = true;
        font = "MonaspiceAr Nerd Font";
        grace = 300;

        clock = true;
        timestr = "%R";
        datestr = "%a, %e of %B";

        image = builtins.toString ./assets/wallpapers/gruvbox_astro.jpg;

        fade-in = "0.2";

        effect-blur = "10x2";
        effect-scale = "0.1";

        indicator = true;
        indicator-radius = 240;
        indicator-thickness = 20;
        indicator-caps-lock = true;

        key-hl-color = combinedColors.blue.rgb;
        bs-hl-color = combinedColors.red.rgb;
        caps-lock-key-hl-color = combinedColors.peach.rgb;
        caps-lock-bs-hl-color = combinedColors.red.rgb;

        separator-color = combinedColors.text.rgb;

        inside-color = combinedColors.crust.rgb;
        inside-clear-color = combinedColors.crust.rgb;
        inside-caps-lock-color = combinedColors.crust.rgb;
        inside-ver-color = combinedColors.crust.rgb;
        inside-wrong-color = combinedColors.crust.rgb;

        ring-color = combinedColors.base.rgb;
        ring-clear-color = combinedColors.blue.rgb;
        ring-caps-lock-color = "231f20D9";
        ring-ver-color = combinedColors.base.rgb;
        ring-wrong-color = combinedColors.red.rgb;

        line-color = combinedColors.blue.rgb;
        line-clear-color = combinedColors.blue.rgb;
        line-caps-lock-color = combinedColors.mauve.rgb;
        line-ver-color = combinedColors.text.rgb;
        line-wrong-color = combinedColors.red.rgb;

        text-color = combinedColors.blue.rgb;
        text-clear-color = combinedColors.crust.rgb;
        text-caps-lock-color = combinedColors.peach.rgb;
        text-ver-color = combinedColors.crust.rgb;
        text-wrong-color = combinedColors.crust.rgb;
        debug = true;
      };
    };
  };
}

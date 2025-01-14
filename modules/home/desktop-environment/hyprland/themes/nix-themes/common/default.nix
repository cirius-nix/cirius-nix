{ namespace, lib, ... }:
let
  inherit (lib) types;
  inherit (lib.${namespace}) mkOpt';
in
{
  options.${namespace}.desktop-environment.hyprland.themes.nix-themes.common = {
    colors = {
      blue = {
        rgb = mkOpt' types.str "#8aadf4"; # Gruvbox Hard BG
      };
      lavender = {
        rgb = mkOpt' types.str "#b7bdf8";
      };
      sapphire = {
        rgb = mkOpt' types.str "#7dc4e4";
      };
      sky = {
        rgb = mkOpt' types.str "#91d7e3";
      };
      teal = {
        rgb = mkOpt' types.str "#8bd5ca";
      };
      green = {
        rgb = mkOpt' types.str "#a6da95";
      };
      yellow = {
        rgb = mkOpt' types.str "#eed49f";
      };
      peach = {
        rgb = mkOpt' types.str "#f5a97f";
      };
      maroon = {
        rgb = mkOpt' types.str "#ee99a0";
      };
      red = {
        rgb = mkOpt' types.str "#ed8796";
      };
      mauve = {
        rgb = mkOpt' types.str "#c6a0f6";
      };
      pink = {
        rgb = mkOpt' types.str "#f5bde6";
      };
      flamingo = {
        rgb = mkOpt' types.str "#f0c6c6";
      };
      rosewater = {
        rgb = mkOpt' types.str "#f4dbd6";
      };
      grey = {
        rgb = mkOpt' types.str "#D9E0EE";
      };
    };
  };
}

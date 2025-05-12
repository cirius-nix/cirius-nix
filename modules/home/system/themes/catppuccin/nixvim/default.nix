{
  config,
  namespace,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (lib.${namespace}) mkEnumOption ifNotNull;
  inherit (import ../constants.nix) variants;

  inherit (config.${namespace}.system) themes;
  inherit (themes) catppuccin;
  inherit (config.${namespace}.development.ide) nixvim;

  dark = ifNotNull catppuccin.nixvim.dark catppuccin.dark;
  light = ifNotNull catppuccin.nixvim.light catppuccin.light;
in
{
  options.${namespace}.system.themes.catppuccin.nixvim = {
    light = mkEnumOption variants null "Light theme";
    dark = mkEnumOption variants null "Dark theme";
    transparent = mkEnableOption "Transparent theme";
  };
  config = mkIf (themes.preset == "catppuccin" && nixvim.enable) {
    programs.nixvim = {
      opts = {
        background = if themes.isDark then "dark" else "light";
      };
      colorschemes.catppuccin = {
        enable = true;
        settings = {
          transparent_background = catppuccin.nixvim.transparent;
          background = {
            inherit dark light;
          };
        };
      };
    };
  };
}

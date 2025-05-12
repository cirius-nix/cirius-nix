{
  config,
  namespace,
  lib,
  ...
}:
let
  inherit (lib) mkIf types;
  inherit (lib.${namespace}) mkEnumOption mkOpt ifNotNull;

  inherit (import ../constants.nix) variants;

  inherit (config.${namespace}.system) themes;
  inherit (themes) catppuccin;
  inherit (config.${namespace}.development.term) kitty;

  dark = ifNotNull catppuccin.kitty.dark catppuccin.dark;
  light = ifNotNull catppuccin.kitty.light catppuccin.light;

  mapTheme = {
    "mocha" = "Catppuccin-Mocha";
    "latte" = "Catppuccin-Latte";
    "frappe" = "Catppuccin-Frappe";
    "macchiato" = "Catppuccin-Macchiato";
  };
in
{
  options.${namespace}.system.themes.catppuccin.kitty = {
    light = mkEnumOption variants null "Light theme";
    dark = mkEnumOption variants null "Dark theme";
    opacity = mkOpt types.float 1 "0..1";
    blur = mkOpt types.int 0 "1..100";
  };
  config = mkIf (themes.preset == "catppuccin" && kitty.enable) {
    programs.kitty = {
      themeFile = mapTheme.${if themes.isDark then dark else light};
      settings = {
        background_opacity = catppuccin.kitty.opacity;
        blur = catppuccin.kitty.blur;
      };
    };
  };
}

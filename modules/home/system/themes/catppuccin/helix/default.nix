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
  inherit (config.${namespace}.development.ide) helix;

  dark = ifNotNull catppuccin.helix.dark catppuccin.dark;
  light = ifNotNull catppuccin.helix.light catppuccin.light;
in
{
  options.${namespace}.system.themes.catppuccin.helix = {
    light = mkEnumOption variants null "Light theme";
    dark = mkEnumOption variants null "Dark theme";
    transparent = mkEnableOption "Transparent theme";
  };
  config = mkIf (themes.preset == "catppuccin" && helix.enable) {
    programs.helix = {
      settings.theme = "catppuccin-${if themes.isDark then dark else light}";
    };
  };
}

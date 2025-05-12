{
  config,
  namespace,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (lib.${namespace}) mkEnumOption ifNotNull;

  inherit (import ../constants.nix) variants;

  inherit (config.${namespace}.system) themes;
  inherit (themes) catppuccin;
  inherit (config.${namespace}.development.cli-utils) btop;

  dark = ifNotNull catppuccin.btop.dark catppuccin.dark;
  light = ifNotNull catppuccin.btop.light catppuccin.light;
  selected = "catppuccin_${if themes.isDark then dark else light}";

  pkg = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "btop";
    rev = "main";
    hash = "sha256-mEGZwScVPWGu+Vbtddc/sJ+mNdD2kKienGZVUcTSl+c=";
  };
in
{
  options.${namespace}.system.themes.catppuccin.btop = {
    light = mkEnumOption variants null "Light theme";
    dark = mkEnumOption variants null "Dark theme";
    transparent = mkEnableOption "Enable transparent background";
  };
  config = mkIf (themes.preset == "catppuccin" && btop.enable) {
    xdg.configFile = {
      "btop/themes/${selected}.theme".source = "${pkg}/themes/${selected}.theme";
    };
    programs.btop = {
      settings = {
        color_theme = selected;
        theme_background = !catppuccin.btop.transparent;
      };
    };
  };
}

{
  config,
  namespace,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkEnumOption mkIntOption ifNotNull;

  inherit (import ../constants.nix) variants accents;

  inherit (config.${namespace}.system) themes;
  inherit (themes) catppuccin;
  inherit (config.${namespace}.development.cli-utils) atuin;

  pkgAtuin = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "atuin";
    rev = "main";
    hash = "sha256-t/Pq+hlCcdSigtk5uzw3n7p5ey0oH/D5S8GO/0wlpKA=";
  };

  themeFiles = builtins.readDir "${pkgAtuin}/themes";

  atuinThemeLinks = lib.mapAttrs' (name: _type: {
    name = ".config/atuin/themes/${name}";
    value = {
      source = "${pkgAtuin}/themes/${name}";
    };
  }) themeFiles;

  dark = ifNotNull catppuccin.atuin.dark.variant catppuccin.dark;
  dAccent = ifNotNull catppuccin.atuin.dark.accent "blue";
  light = ifNotNull catppuccin.atuin.light.variant catppuccin.light;
  lAccent = ifNotNull catppuccin.atuin.light.accent "blue";

  darkTheme = "catppuccin-${dark}-${dAccent}";
  lightTheme = "catppuccin-${light}-${lAccent}";
in
{
  options.${namespace}.system.themes.catppuccin.atuin = {
    light = {
      variant = mkEnumOption variants null "Light theme";
      accent = mkEnumOption accents null "accent to be used";
    };
    dark = {
      variant = mkEnumOption variants null "Dark theme";
      accent = mkEnumOption accents null "accent to be used";
    };
    maxDepth = mkIntOption 10 "Max depth of the tree";
  };
  config = mkIf (themes.preset == "catppuccin" && atuin.enable) {
    home.file = atuinThemeLinks;
    programs.atuin = {
      settings = {
        theme = {
          name = if themes.isDark then darkTheme else lightTheme;
          debug = false;
          max_depth = catppuccin.atuin.maxDepth;
        };
      };
    };
  };
}

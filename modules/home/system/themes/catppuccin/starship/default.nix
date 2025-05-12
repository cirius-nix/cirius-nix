{
  config,
  namespace,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkEnumOption ifNotNull;

  inherit (import ../constants.nix) variants;

  inherit (config.${namespace}.system) themes;
  inherit (themes) catppuccin;
  inherit (config.${namespace}.development.cli-utils) starship;

  dark = ifNotNull catppuccin.starship.dark catppuccin.dark;
  light = ifNotNull catppuccin.starship.light catppuccin.light;
  selected = if themes.isDark then dark else light;

  pkg = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "starship";
    rev = "main";
    hash = "sha256-1w0TJdQP5lb9jCrCmhPlSexf0PkAlcz8GBDEsRjPRns=";
  };
  themeSetting = builtins.fromTOML (builtins.readFile "${pkg}/themes/${selected}.toml");
in
{
  options.${namespace}.system.themes.catppuccin.starship = {
    light = mkEnumOption variants null "Light theme";
    dark = mkEnumOption variants null "Dark theme";
  };
  config = mkIf (themes.preset == "catppuccin" && starship.enable) {
    programs.starship = {
      settings = {
        palette = "catppuccin_${selected}";
      } // themeSetting;
    };
  };
}

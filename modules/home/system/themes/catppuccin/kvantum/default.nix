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

  inherit (import ../constants.nix) variants accents;

  inherit (config.${namespace}.system) themes;
  inherit (themes) catppuccin;
  inherit (config.${namespace}.desktop-environment.shared.plugins) kvantum;

  dark = ifNotNull catppuccin.kvantum.dark.variant catppuccin.dark;
  dAccent = ifNotNull catppuccin.kvantum.dark.accent "blue";
  light = ifNotNull catppuccin.kvantum.light.variant catppuccin.light;
  lAccent = ifNotNull catppuccin.kvantum.light.accent "blue";

  pkg = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "kvantum";
    rev = "main";
    hash = "sha256-9DVVUFWhKNe2x3cNVBI78Yf5reh3L22Jsu1KKpKLYsU=";
  };
  themeFiles = builtins.readDir "${pkg}/themes";
  themeLinks = lib.mapAttrs' (name: _type: {
    name = ".config/Kvantum/${name}";
    value = {
      source = "${pkg}/themes/${name}";
    };
  }) themeFiles;
in
{
  options.${namespace}.system.themes.catppuccin.kvantum = {
    light = {
      variant = mkEnumOption variants null "Light theme";
      accent = mkEnumOption accents null "Accent to be used";
    };
    dark = {
      variant = mkEnumOption variants null "Dark theme";
      accent = mkEnumOption accents null "Accent to be used";
    };
  };
  config = mkIf (themes.preset == "catppuccin" && kvantum.enable) {
    home.file = themeLinks;
    ${namespace}.desktop-environment.shared.plugins.kvantum = {
      settings = {
        General =
          let
            variant = if themes.isDark then dark else light;
            accent = if themes.isDark then dAccent else lAccent;
          in
          {
            theme = "catppuccin-${variant}-${accent}";
          };
      };
    };
  };
}

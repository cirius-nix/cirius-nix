{
  pkgs,
  config,
  namespace,
  lib,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkEnumOption ifNotNull;

  inherit (import ../constants.nix)
    variants
    styles
    accents
    ;

  inherit (config.${namespace}.system) themes;
  inherit (themes) catppuccin;

  dark = ifNotNull catppuccin.kde.dark.variant catppuccin.dark;
  light = ifNotNull catppuccin.kde.light.variant catppuccin.light;
  selected = if themes.isDark then dark else light;

  mapVariants = {
    "mocha" = "Mocha";
    "latte" = "Latte";
    "frappe" = "Frappe";
    "macchiato" = "Macchiato";
  };

  mapAuroraeStyle = {
    "classic" = "Classic";
    "modern" = "Modern";
  };

  pkg = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "kde";
    rev = "main";
    hash = "sha256-+/+8ECnxf9gyci/fl4jGaGAx0y9z3gDM555CNF1X6iE=";
  };

  auroraeThemeName = "Catppuccin${mapVariants.${selected}}-${
    mapAuroraeStyle.${catppuccin.kde.style}
  }";
  auroraeFiles = builtins.readDir "${pkg}/Resources/Aurorae/${auroraeThemeName}";
  auroraeLinks =
    let
      style = mapAuroraeStyle.${catppuccin.kde.style};
    in
    (lib.mapAttrs' (name: _type: {
      name = ".local/share/aurorae/themes/${auroraeThemeName}/${name}";
      value = {
        source = "${pkg}/Resources/Aurorae/${auroraeThemeName}/${name}";
      };
    }) auroraeFiles)
    // {
      ".local/share/aurorae/themes/${auroraeThemeName}/Catppuccin-${style}rc".source =
        "${pkg}/Resources/Aurorae/Common/Catppuccin-${style}rc";
    };
in
{
  options.${namespace}.system.themes.catppuccin.kde = {
    style = mkEnumOption styles "modern" "Style of the theme";
    light = {
      variant = mkEnumOption variants null "Light theme";
      accent = mkEnumOption accents null "accent to be used";
    };
    dark = {
      variant = mkEnumOption variants null "Dark theme";
      accent = mkEnumOption accents null "accent to be used";
    };
  };
  config = mkIf pkgs.stdenv.isLinux {
    home.file = auroraeLinks;
  };
}

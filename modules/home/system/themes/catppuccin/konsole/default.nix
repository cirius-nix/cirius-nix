{
  config,
  namespace,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    types
    ;
  inherit (lib.${namespace}) mkEnumOption mkOpt ifNotNull;

  inherit (import ../constants.nix) variants;

  inherit (config.${namespace}.system) themes;
  inherit (themes) catppuccin;
  inherit (config.${namespace}.development.term) konsole;

  dark = ifNotNull catppuccin.konsole.dark catppuccin.dark;
  light = ifNotNull catppuccin.konsole.light catppuccin.light;

  themeFiles = builtins.readDir "${pkgs.${namespace}.catppuccin-konsole}/json-themes";
in
{
  options.${namespace}.system.themes.catppuccin.konsole = {
    light = mkEnumOption variants null "Light theme";
    dark = mkEnumOption variants null "Dark theme";
    opacity = mkOpt types.int 0 "0..100";
    blur = mkEnableOption "Enable blur feature";
  };
  config = mkIf (themes.preset == "catppuccin" && konsole.enable) {
    home = {
      packages = with pkgs.${namespace}; [
        catppuccin-konsole
      ];
      file = pkgs.lib.mapAttrs' (
        name: _type:
        let
          themePath = "${pkgs.${namespace}.catppuccin-konsole}/json-themes/${name}";
          parsed = builtins.fromJSON (builtins.readFile themePath);
          modified = parsed // {
            General = (parsed.General or { }) // {
              inherit (catppuccin.konsole) opacity blur;
            };
          };
          iniContent = lib.generators.toINI { } modified;
        in
        {
          name = ".local/share/konsole/${name}";
          value.source = pkgs.writeText name iniContent;
        }
      ) themeFiles;
    };
    ${namespace}.development.term.konsole = {
      profile = {
        Appearance = {
          ColorScheme = "catppuccin-${if themes.isDark then dark else light}";
        };
      };
      settings = {
        UiSettings = {
          ColorScheme = "catppuccin-${if themes.isDark then dark else light}";
        };
      };
    };
  };
}

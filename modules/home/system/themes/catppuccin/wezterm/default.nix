{
  config,
  namespace,
  lib,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkEnumOption ifNotNull;

  inherit (import ../constants.nix) variants;

  inherit (config.${namespace}.system) themes;
  inherit (themes) catppuccin;
  inherit (config.${namespace}.development.term) wezterm;

  mapTheme = {
    "mocha" = "Catppuccin Mocha";
    "latte" = "Catppuccin Latte";
    "frappe" = "Catppuccin Frappe";
    "macchiato" = "Catppuccin Macchiato";
  };

  dark = ifNotNull catppuccin.wezterm.dark catppuccin.dark;
  light = ifNotNull catppuccin.wezterm.light catppuccin.light;
in
{
  options.${namespace}.system.themes.catppuccin.wezterm = {
    light = mkEnumOption variants null "Light theme";
    dark = mkEnumOption variants null "Dark theme";
  };
  config = mkIf (themes.preset == "catppuccin" && wezterm.enable) {
    ${namespace} = {
      development.term = {
        wezterm = {
          colorscheme = lib.mkForce mapTheme.${if themes.isDark then dark else light};
        };
      };
    };
  };
}

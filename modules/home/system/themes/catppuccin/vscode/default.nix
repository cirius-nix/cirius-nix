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
  inherit (config.${namespace}.development.ide) vscode;

  dark = ifNotNull catppuccin.vscode.dark catppuccin.dark;
  light = ifNotNull catppuccin.vscode.light catppuccin.light;

  mapTheme = {
    "mocha" = "Catppuccin Mocha";
    "latte" = "Catppuccin Latte";
    "frappe" = "Catppuccin Frappe";
    "macchiato" = "Catppuccin Macchiato";
  };

  mapIconTheme = {
    "mocha" = "catppuccin-mocha";
    "latte" = "catppuccin-latte";
    "frappe" = "catppuccin-frappe";
    "macchiato" = "catppuccin-macchiato";
  };
in
{
  options.${namespace}.system.themes.catppuccin.vscode = {
    light = mkEnumOption variants null "Light theme";
    dark = mkEnumOption variants null "Dark theme";
  };
  config = mkIf (themes.preset == "catppuccin" && vscode.enable) {
    programs.vscode = {
      profiles.default = {
        extensions = with pkgs; [
          vscode-extensions.catppuccin.catppuccin-vsc
          vscode-extensions.catppuccin.catppuccin-vsc-icons
        ];
        userSettings = {
          "workbench.colorTheme" = mapTheme.${if themes.isDark then dark else light};
          "workbench.iconTheme" = mapIconTheme.${if themes.isDark then dark else light};
        };
      };
    };
  };
}

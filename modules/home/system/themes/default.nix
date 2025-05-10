{
  namespace,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption;
  inherit (lib.${namespace}) mkEnumOption;
in
{
  options.${namespace}.system.themes = {
    enable = mkEnableOption "Enable theming module";
    isDark = mkEnableOption "Set theme to dark mode";
    preset = mkEnumOption [
      "catppuccin"
    ] "catppuccin" "Theme preset";
  };
}

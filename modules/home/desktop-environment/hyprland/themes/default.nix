{
  config,
  namespace,
  lib,
  pkgs,
  ...
}:
let
  deCfg = config.${namespace}.desktop-environment;
  hyprCfg = deCfg.hyprland;

  inherit (lib) types mkIf mkOption;
  inherit (lib.${namespace}) mkOpt;
in
{
  options.${namespace}.desktop-environment.hyprland.themes = {
    activatedTheme = mkOption {
      description = "Theme module";
      type = types.submodule {
        options = {
          cursor = {
            package = mkOpt types.package null "The package to use for the cursor theme.";
            name = mkOpt types.str "" "The name of the cursor theme to apply.";
            size = mkOpt types.int 32 "The size of the cursor.";
          };
          icon = {
            package = mkOpt types.package null "The package to use for the icon theme.";
            name = mkOpt types.str "" "The name of the icon theme to apply.";
          };
          gtk-theme = {
            name = mkOpt types.str "" "The name of the theme to apply";
            package = mkOpt types.package null "The package to use for the theme";
          };
          qt-theme = {
            kvantum-source = mkOpt types.path null "Path to the kvantum source";
            colorscheme-path = mkOpt types.path null "Path to custom qt colorscheme";
          };
          colors = {
            base = {
              rgb = mkOpt types.str "" "Background color"; # Gruvbox Hard BG
            };
            crust = {
              rgb = mkOpt types.str "" "Darkest background"; # Extra dark, rename if needed
            };
            mantle = {
              rgb = mkOpt types.str "" "Very dark background"; # Between crust & base
            };
            text = {
              rgb = mkOpt types.str "" "Text color"; # Gruvbox FG
            };
            textAlt = {
              rgb = mkOpt types.str "" "Alternative text";
            };
            subtext0 = {
              rgb = mkOpt types.str "" "Muted text color";
            };
            subtext1 = {
              rgb = mkOpt types.str "" "Brighter muted text";
            };
            surface0 = {
              rgb = mkOpt types.str "" "Surface dark";
            };
            surface1 = {
              rgb = mkOpt types.str "" "Surface slightly lighter";
            };
            surface2 = {
              rgb = mkOpt types.str "" "Surface brighter";
            };
            overlay0 = {
              rgb = mkOpt types.str "" "Overlay dark";
            };
            overlay1 = {
              rgb = mkOpt types.str "" "Overlay mid";
            };
            overlay2 = {
              rgb = mkOpt types.str "" "Overlay bright";
            };
          };
        };
      };
    };
    combinedColors = mkOption {
      type = types.attrs;
    };
    cssColorVars = mkOpt types.str "" "css color variables for hyprland theme";
    standardColorVars = mkOpt types.str "" "standard color variables for hyprland theme";
  };
  config = mkIf (pkgs.stdenv.isLinux && deCfg.kind == "hyprland") (
    let
      inherit (hyprCfg.themes) activatedTheme;
    in
    {
      home = {
        packages = [
          activatedTheme.cursor.package
          activatedTheme.icon.package
          activatedTheme.gtk-theme.package
        ];
      };

      ${namespace}.desktop-environment.hyprland.themes =
        let
          combinedColors = activatedTheme.colors // hyprCfg.themes.nix-themes.common.colors;
        in
        {
          inherit combinedColors;
          cssColorVars = builtins.concatStringsSep " " (
            lib.attrsets.mapAttrsToList (name: value: "@define-color ${name} ${value.rgb};") combinedColors
          );
          standardColorVars = builtins.concatStringsSep " " (
            lib.attrsets.mapAttrsToList (name: value: "${name}: ${value.rgb};") combinedColors
          );
        };
    }
  );
}

{
  config,
  lib,
  namespace,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
  hyprCfg = config.${namespace}.desktop-environment.hyprland;
in
{
  config = mkIf (pkgs.stdenv.isLinux && hyprCfg.theme == "gruvbox") {
    ${namespace}.desktop-environment.hyprland.themes.activatedTheme = {
      cursor = {
        package = pkgs.capitaine-cursors-themed;
        name = "Capitaine Cursors (Gruvbox)";
        size = 32;
      };
      icon = {
        package = pkgs.gruvbox-plus-icons;
        name = "Gruvbox-Plus-Dark";
      };
      gtk-theme = {
        name = "Zukitre-dark"; # Zukitre-dark | Zukitwo-dark | Zukitre | Zukitwo
        package = pkgs.zuki-themes;
      };
      qt-theme = {
        kvantum-source = ./assets/kvantum;
        colorscheme-path = ./assets/qt5ct/colors/gruvbox.conf;
      };
      colors = {
        base = {
          rgb = "#1d2021";
        };
        crust = {
          rgb = "#121212";
        };
        mantle = {
          rgb = "#171717";
        };
        text = {
          rgb = "#ebdbb2";
        };
        textAlt = {
          rgb = "#F28FAD";
        };
        subtext0 = {
          rgb = "#928374";
        };
        subtext1 = {
          rgb = "#a89984";
        };
        surface0 = {
          rgb = "#1d2021";
        };
        surface1 = {
          rgb = "#282828";
        };
        surface2 = {
          rgb = "#3c3836";
        };
        overlay0 = {
          rgb = "#504945";
        };
        overlay1 = {
          rgb = "#665c54";
        };
        overlay2 = {
          rgb = "#7c6f64";
        };
      };
    };
  };
}

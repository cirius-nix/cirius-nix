{
  config,
  namespace,
  lib,
  pkgs,
  ...
}:
let
  themes = config.${namespace}.system.themes;
  cfg = config.${namespace}.system.themes.catppuccin;

  inherit (lib) mkIf types mkEnableOption;
  inherit (lib.${namespace})
    mkEnumOption
    mkOpt
    subModuleType
    optionalGet
    ifNullThen
    ;

  variants = [
    "mocha"
    "latte"
    "frappe"
    "macchiato"
  ];

  overrideThemeType = types.nullOr (subModuleType {
    light = mkEnumOption variants "latte" "Light theme";
    dark = mkEnumOption variants "mocha" "Dark theme";
  });
in
{
  options.${namespace}.system.themes.catppuccin = {
    light = mkEnumOption variants "latte" "Light theme";
    dark = mkEnumOption variants "mocha" "Dark theme";
    vscode = mkOpt overrideThemeType null "Override VSCode variant";
    nixvim = mkOpt (types.nullOr (subModuleType {
      light = mkEnumOption variants "latte" "Light theme";
      dark = mkEnumOption variants "mocha" "Dark theme";
      transparent = mkEnableOption "Transparent theme";
    })) null "Override NixVim variant";
    kitty = mkOpt (types.nullOr (subModuleType {
      light = mkEnumOption variants "latte" "Light theme";
      dark = mkEnumOption variants "mocha" "Dark theme";
      opacity = mkOpt types.float 1 "0..1";
      blur = mkOpt types.int 0 "1..100";
    })) null "Override Kitty variant";
  };

  config = mkIf (themes.preset == "catppuccin") {
    programs = {
      nixvim =
        let
          dark = ifNullThen (optionalGet [ "nixvim" "dark" ] cfg) cfg.dark;
          light = ifNullThen (optionalGet [ "nixvim" "light" ] cfg) cfg.light;
        in
        mkIf (config.${namespace}.development.ide.nixvim.enable) {
          opts = {
            background = if themes.isDark then "dark" else "light";
          };
          colorschemes.catppuccin = {
            enable = true;
            settings = {
              background = {
                inherit dark light;
              };
              transparent_background = ifNullThen (optionalGet [ "nixvim" "transparent" ] cfg) false;
            };
          };
        };
      kitty =
        let
          dark = ifNullThen (optionalGet [ "nixvim" "dark" ] cfg) cfg.dark;
          light = ifNullThen (optionalGet [ "nixvim" "light" ] cfg) cfg.light;
          selectedVariant = if themes.isDark then dark else light;

          mapVariantTheme = {
            "mocha" = "Catppuccin-Mocha";
            "latte" = "Catppuccin-Latte";
            "frappe" = "Catppuccin-Frappe";
            "macchiato" = "Catppuccin-Macchiato";
          };
        in
        {
          themeFile = mapVariantTheme.${selectedVariant};
          settings = {
            background_opacity = ifNullThen (optionalGet [ "kitty" "opacity" ] cfg) 1;
            background_blur = ifNullThen (optionalGet [ "kitty" "blur" ] cfg) 0;
          };
        };
      vscode =
        let
          dark = ifNullThen (optionalGet [ "vscode" "dark" ] cfg) cfg.dark;
          light = ifNullThen (optionalGet [ "vscode" "light" ] cfg) cfg.light;
          selectedVariant = if themes.isDark then dark else light;

          mapVariantTheme = {
            "mocha" = "Catppuccin Mocha";
            "latte" = "Catppuccin Latte";
            "frappe" = "Catppuccin Frappe";
            "macchiato" = "Catppuccin Macchiato";
          };

          mapVariantIcon = {
            "mocha" = "catppuccin-mocha";
            "latte" = "catppuccin-latte";
            "frappe" = "catppuccin-frappe";
            "macchiato" = "catppuccin-macchiato";
          };
        in
        mkIf (config.${namespace}.development.ide.vscode.enable) {
          profiles.default = {
            userSettings = {
              "workbench.colorTheme" = mapVariantTheme.${selectedVariant};
              "workbench.iconTheme" = mapVariantIcon.${selectedVariant};
            };
            extensions = with pkgs.vscode-extensions; [
              catppuccin.catppuccin-vsc
              catppuccin.catppuccin-vsc-icons
            ];
          };
        };
    };
  };
}

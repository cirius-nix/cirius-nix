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

  commonThemeOptionType = types.nullOr (subModuleType {
    stopSync = mkEnableOption "Stop to sync theme with system";
    light = mkEnumOption variants "latte" "Light theme";
    dark = mkEnumOption variants "mocha" "Dark theme";
  });

  extractAppCfg = name: rec {
    stopSync = ifNullThen (cfg [ name "stopSync" ] false);
    dark = ifNullThen (optionalGet cfg [
      name
      "dark"
    ]) cfg.dark;
    light = ifNullThen (optionalGet cfg [
      name
      "light"
    ]) cfg.light;
    selected = if themes.isDark then dark else light;
  };
in
{
  options.${namespace}.system.themes.catppuccin = {
    light = mkEnumOption variants "latte" "Light theme";
    dark = mkEnumOption variants "mocha" "Dark theme";
    vscode = mkOpt commonThemeOptionType null "Override VSCode variant";
    helix = mkOpt commonThemeOptionType null "Override NixVim variant";
    nixvim = mkOpt (types.nullOr (subModuleType {
      light = mkEnumOption variants "latte" "Light theme";
      dark = mkEnumOption variants "mocha" "Dark theme";
      transparent = mkEnableOption "Transparent theme";
    })) null "Override NixVim variant";
    wezterm = mkOpt (types.nullOr (subModuleType {
      light = mkEnumOption variants "latte" "Light theme";
      dark = mkEnumOption variants "mocha" "Dark theme";
      opacity = mkOpt types.float 1 "0..1";
      blur = mkOpt types.int 0 "1..100";
    })) null "Override wezterm variant";
    kitty = mkOpt (types.nullOr (subModuleType {
      light = mkEnumOption variants "latte" "Light theme";
      dark = mkEnumOption variants "mocha" "Dark theme";
      opacity = mkOpt types.float 1 "0..1";
      blur = mkOpt types.int 0 "1..100";
    })) null "Override Kitty variant";
    konsole = mkOpt (types.nullOr (subModuleType {
      light = mkEnumOption variants "latte" "Light theme";
      dark = mkEnumOption variants "mocha" "Dark theme";
      opacity = mkOpt types.int 0 "0..100";
      blur = mkEnableOption "Enable blur feature";
    })) null "Override konsole variant";
  };

  config = mkIf (themes.preset == "catppuccin") {
    home.packages = [
      pkgs.${namespace}.catppuccin-konsole
    ];
    home.file =
      { }
      // lib.optionals (config.${namespace}.development.term.konsole.enable) (
        let
          opacity = ifNullThen (optionalGet cfg [
            "konsole"
            "opacity"
          ]) 0;
          blur = ifNullThen (optionalGet cfg [
            "konsole"
            "blur"
          ]) false;

          themeFiles = builtins.readDir "${pkgs.${namespace}.catppuccin-konsole}/json-themes";
          themeLinks = pkgs.lib.mapAttrs' (
            name: _type:
            let
              themePath = "${pkgs.${namespace}.catppuccin-konsole}/json-themes/${name}";
              parsed = builtins.fromJSON (builtins.readFile themePath);
              modified = parsed // {
                General = (parsed.General or { }) // {
                  inherit opacity blur;
                };
              };
              iniContent = lib.generators.toINI { } modified;
            in
            {
              name = ".local/share/konsole/${lib.removeSuffix ".json" name}.colorscheme";
              value.source = pkgs.writeText "${lib.removeSuffix ".json" name}.colorscheme" iniContent;
            }
          ) themeFiles;
        in
        themeLinks
      );
    ${namespace} = {
      development.term = {
        konsole =
          let
            appCfg = extractAppCfg "konsole";
            mapVariantTheme = {
              "mocha" = "catppuccin-mocha";
              "latte" = "catppuccin-latte";
              "frappe" = "catppuccin-frappe";
              "macchiato" = "catppuccin-macchiato";
            };

          in
          {
            profile = {
              Appearance = {
                ColorScheme = mapVariantTheme.${appCfg.selected};
              };
            };
            settings = {
              UiSettings = {
                ColorScheme = mapVariantTheme.${appCfg.selected};
              };
            };
          };
        wezterm =
          let
            appCfg = extractAppCfg "wezterm";
            mapVariantTheme = {
              "mocha" = "Catppuccin Mocha";
              "latte" = "Catppuccin Latte";
              "frappe" = "Catppuccin Frappe";
              "macchiato" = "Catppuccin Macchiato";
            };
          in
          {
            colorscheme = lib.mkForce mapVariantTheme.${appCfg.selected};
          };
      };
    };
    programs = {
      helix =
        let
          appCfg = extractAppCfg "helix";
          mapVariantTheme = {
            "mocha" = "catppuccin-mocha";
            "latte" = "catppuccin-latte";
            "frappe" = "catppuccin-frappe";
            "macchiato" = "catppuccin-macchiato";
          };
        in
        mkIf config.${namespace}.development.ide.helix.enable {
          settings = {
            theme = mapVariantTheme.${appCfg.selected};
          };
        };
      nixvim = mkIf config.${namespace}.development.ide.nixvim.enable {
        opts = {
          background = if themes.isDark then "dark" else "light";
        };
        colorschemes.catppuccin = {
          enable = true;
          settings = {
            background = {
              inherit (extractAppCfg "nixvim") dark light;
            };
            transparent_background = ifNullThen (optionalGet cfg [
              "nixvim"
              "transparent"
            ]) false;
          };
        };
      };
      kitty =
        let
          appCfg = extractAppCfg "kitty";
          mapVariantTheme = {
            "mocha" = "Catppuccin-Mocha";
            "latte" = "Catppuccin-Latte";
            "frappe" = "Catppuccin-Frappe";
            "macchiato" = "Catppuccin-Macchiato";
          };
        in
        mkIf config.${namespace}.development.term.kitty.enable {
          themeFile = mapVariantTheme.${appCfg.selected};
          settings = {
            background_opacity = ifNullThen (optionalGet cfg [
              "kitty"
              "opacity"
            ]) 1;
            background_blur = ifNullThen (optionalGet cfg [
              "kitty"
              "blur"
            ]) 0;
          };
        };
      vscode =
        let
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
        mkIf config.${namespace}.development.ide.vscode.enable {
          profiles.default =
            let
              appCfg = extractAppCfg "vscode";
            in
            {
              userSettings = {
                "workbench.colorTheme" = mapVariantTheme.${appCfg.selected};
                "workbench.iconTheme" = mapVariantIcon.${appCfg.selected};
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

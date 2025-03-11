{
  config,
  lib,
  pkgs,
  namespace,
  osConfig,
  ...
}:
let
  inherit (lib)
    mkIf
    mkForce
    getExe
    mkMerge
    types
    ;
  inherit (lib.${namespace}) mkOpt mkBoolOpt;

  deCfg = config.${namespace}.desktop-environment;
  hyprCfg = deCfg.hyprland;
  cfg = hyprCfg.bar;

  style = builtins.readFile ./styles/index.waybar.css;
  controlCenterStyle = builtins.readFile ./styles/control-center.waybar.css;
  powerStyle = builtins.readFile ./styles/power.waybar.css;
  statsStyle = builtins.readFile ./styles/stats.waybar.css;
  workspacesStyle = builtins.readFile ./styles/workspaces.waybar.css;
  trayStyle = builtins.readFile ./styles/tray.waybar.css;

  custom-modules = import ./bar-modules/custom.nix { inherit config lib pkgs; };
  default-modules = import ./bar-modules/main.nix { inherit lib pkgs; };
  group-modules = import ./bar-modules/group.nix { inherit lib namespace osConfig; };
  hyprland-modules = import ./bar-modules/hypr.nix { inherit config lib; };

  commonAttributes = {
    layer = "top";
    position = "top";

    margin-top = 10;
    margin-left = 20;
    margin-right = 20;

    modules-left =
      [ "custom/power" ]
      ++ lib.optionals (deCfg.kind == "hyprland") [
        "hyprland/workspaces"
      ]
      ++ [ "custom/separator-left" ]
      ++ lib.optionals (deCfg.kind == "hyprland") [ "hyprland/window" ];
  };

  fullSizeModules = {
    modules-right =
      [
        "custom/separator-right"
        "group/stats"
        "group/tray"
        "group/control-center"
        "clock"
      ]
      ++ lib.optionals (deCfg.kind == "hyprland") [ "hyprland/submap" ]
      ++ [
        # "custom/weather"
      ];
  };

  condensedModules = {
    modules-right =
      [
        "group/tray-drawer"
        "group/stats-drawer"
        "group/control-center"
      ]
      ++ lib.optionals (deCfg.kind == "hyprland") [ "hyprland/submap" ]
      ++ [
        "custom/weather"
        "clock"
      ];
  };

  mkBarSettings =
    barType:
    mkMerge [
      commonAttributes
      (if barType == "fullSize" then fullSizeModules else condensedModules)
      custom-modules
      default-modules
      group-modules
      (lib.mkIf (deCfg.kind == "hyprland") hyprland-modules)
    ];

  generateOutputSettings =
    outputList: barType:
    builtins.listToAttrs (
      builtins.map (outputName: {
        name = outputName;
        value = mkMerge [
          (mkBarSettings barType)
          { output = outputName; }
        ];
      }) outputList
    );

  enabled = pkgs.stdenv.isLinux && deCfg.kind == "hyprland" && cfg.enable;
in
{
  options.${namespace}.desktop-environment.hyprland.bar = {
    enable = mkBoolOpt false "Whether to enable waybar in the desktop environment.";
    debug = mkBoolOpt false "Whether to enable debug mode.";
    fullSizeOutputs =
      mkOpt (types.listOf types.str) "Which outputs to use the full size waybar on."
        [ ];
    condensedOutputs =
      mkOpt (types.listOf types.str) "Which outputs to use the smaller size waybar on."
        [ ];
  };

  config = mkIf enabled {
    systemd.user.services.waybar.Service.ExecStart = mkIf cfg.debug (
      mkForce "${getExe pkgs.waybar} -l debug"
    );

    home.packages = with pkgs; [
      coreutils
      helvum
    ];

    programs.waybar = {
      enable = true;
      systemd.enable = true;
      settings = mkMerge [
        (generateOutputSettings cfg.fullSizeOutputs "fullSize")
        (generateOutputSettings cfg.condensedOutputs "condensed")
      ];
      style = "${hyprCfg.themes.cssColorVars}${style}${controlCenterStyle}${powerStyle}${statsStyle}${workspacesStyle}${trayStyle}";
    };
  };
}

{
  config,
  lib,
  namespace,
  pkgs,
  osConfig,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    ;
  dependencies = with pkgs; [
    bash
    config.wayland.windowManager.hyprland.package
    coreutils
    grim
    hyprpicker
    jq
    libnotify
    slurp
    wl-clipboard
  ];
  deCfg = config.${namespace}.desktop-environment;
  hyprCfg = deCfg.hyprland;
  cfg = hyprCfg.services.swaync;
  enabled = pkgs.stdenv.isLinux && deCfg.kind == "hyprland" && cfg.enable;
  settings = import ./settings.nix { inherit lib osConfig pkgs; };
  style = import ./style.nix { inherit (hyprCfg.themes) cssColorVars; };
in
{
  options.${namespace}.desktop-environment.hyprland.services.swaync = {
    enable = mkEnableOption "swaync";
  };
  config = mkIf enabled {
    home.packages = dependencies;
    services = {
      swaync = {
        enable = true;
        package = pkgs.swaynotificationcenter;
        inherit settings;
        inherit (style) style;
      };
    };
    systemd.user.services.swaync.Service.Environment =
      "PATH=/run/wrappers/bin:${lib.makeBinPath dependencies}";
  };
}

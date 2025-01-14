{
  config,
  lib,
  namespace,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.core.wlroots;
in
{
  options.${namespace}.core.wlroots = {
    enable = mkBoolOpt false "Enable common wlroots configuration.";
  };

  config = mkIf cfg.enable {
    services = {
      seatd = {
        enable = true;
      };
    };
    programs = {
      nm-applet.enable = true;
      xwayland.enable = true;
      wshowkeys = {
        enable = true;
        package = pkgs.wshowkeys;
      };
    };
  };
}

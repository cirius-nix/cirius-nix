{
  config,
  lib,
  namespace,
  ...
}:

let
  inherit (lib) mkIf;
  deCfg = config.${namespace}.desktop-environment;
in
{
  config = mkIf (deCfg.kind == "deepin") {
    services = {
      xserver = {
        desktopManager.deepin.enable = true;
        displayManager.lightdm.enable = true;
        enable = true;
      };
    };
  };
}

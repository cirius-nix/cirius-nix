{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:

let
  inherit (lib) mkIf;
  deCfg = config.${namespace}.desktop-environment;
in
{

  config = mkIf (deCfg.kind == "kde") {
    environment.systemPackages = with pkgs; [
      latte-dock
      kdePackages.kconfig
    ];
  };
}

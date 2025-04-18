{
  lib,
  pkgs,
  config,
  namespace,
  ...
}:
let
  deModuleCfg = config.${namespace}.desktop-environment;
in
{
  config = lib.mkIf (pkgs.stdenv.isLinux && deModuleCfg.kind == "kde") {
    # This configuration block applies only if the system is Linux-based
    # and the desktop environment is set to KDE.
    home.packages = with pkgs; [
    ];
  };
}

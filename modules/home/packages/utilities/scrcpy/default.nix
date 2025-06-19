{
  namespace,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (config.${namespace}.packages.utilities) scrcpy;
in
{
  options.${namespace}.packages.utilities.scrcpy = {
    enable = mkEnableOption "Enable scrcpy";
  };
  config = mkIf (scrcpy.enable && pkgs.stdenv.isLinux) {
    home.packages = [ pkgs.qtscrcpy ];
  };
}

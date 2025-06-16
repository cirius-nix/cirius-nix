{
  pkgs,
  config,
  namespace,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  inherit (config.${namespace}.packages.utilities) raycast;
in
{
  options.${namespace}.packages.utilities.raycast = {
    enable = mkEnableOption "Enable raycast";
  };

  config = mkIf (raycast.enable && pkgs.stdenv.isDarwin) {
    home.packages = [ pkgs.raycast ];
  };
}

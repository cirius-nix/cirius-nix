{
  config,
  namespace,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (config.${namespace}.packages.utilities) android-tools;
in
{
  options.${namespace}.packages.utilities.android-tools.enable =
    mkEnableOption "Enable Android tools";
  config = mkIf android-tools.enable {
    home.packages = [
      pkgs.android-tools
    ];
  };
}

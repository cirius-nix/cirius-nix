{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.${namespace}.development.kdev;
in
{
  options.${namespace}.development.kdev = {
    enable = mkEnableOption "KDev";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      kdePackages.kdevelop
      kdePackages.qttools
      kdePackages.kconfig
      qtcreator
    ];
  };
}

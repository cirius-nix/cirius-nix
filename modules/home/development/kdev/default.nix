{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.cirius.development.kdev;
in
{
  options.cirius.development.kdev = {
    enable = mkEnableOption "KDev";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      kdePackages.kdevelop
      kdePackages.qttools
    ];
  };
}

{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.cirius.kde;
in
{
  options.cirius.kde = {
    enable = mkEnableOption "KDE";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      latte-dock
      kdePackages.kconfig
      kdePackages.filelight
    ];
  };
}

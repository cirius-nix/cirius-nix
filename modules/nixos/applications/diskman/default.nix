{
  config,
  namespace,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.${namespace}.applications.diskman;
in
{
  options.${namespace}.applications.diskman = {
    enable = lib.mkEnableOption "Toggle Disk Manager";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      kdePackages.partitionmanager
      kdePackages.filelight
      baobab
      smartmontools
    ];
  };
}

{
  config,
  lib,
  namespace,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.applications.home-manager;
in
{
  options.${namespace}.applications.home-manager = {
    enable = mkEnableOption "home-manager";
  };

  config = mkIf cfg.enable {
    home-manager = {
      backupFileExtension = "./hm-backup";
      useUserPackages = true;
      useGlobalPkgs = true;
    };
  };
}

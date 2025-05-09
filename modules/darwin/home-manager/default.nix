{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.${namespace}.home-manager;
in
{
  options.${namespace}.home-manager = {
    enable = mkEnableOption "home-manager";
  };

  config = mkIf cfg.enable {
    home-manager = {
      backupFileExtension = "hm-backup";
      useUserPackages = true;
      useGlobalPkgs = true;
    };
  };
}

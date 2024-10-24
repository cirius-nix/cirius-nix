{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.cirius.home-manager;
in
{
  options.cirius.home-manager = {
    enable = mkEnableOption "home-manager";
  };

  config = mkIf cfg.enable {
    home-manager = {
      useUserPackages = true;
      useGlobalPkgs = true;
    };
  };
}

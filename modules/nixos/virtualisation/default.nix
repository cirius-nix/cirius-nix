{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.cirius.virtualisation;
in
{
  options.cirius.virtualisation = {
    enable = mkEnableOption "Virtualisation";
  };

  config = mkIf cfg.enable {
    virtualisation = {
      podman = {
        enable = true;
      };
      waydroid = {
        enable = true;
      };
    };
  };
}

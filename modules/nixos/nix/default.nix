{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.cirius.nix;
in
{
  options.cirius.nix = {
    enable = mkEnableOption "Nix";
  };

  config = mkIf cfg.enable {
    nix = {
      # package = pkgs.nixVersions.latest;
      settings.experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };
}

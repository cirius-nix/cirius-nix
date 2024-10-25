{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf;

  devCfg = config.cirius.development;
  cfg = devCfg.starship;
  fishCfg = devCfg.fish;
in
{
  options.cirius.development.starship = {
    enable = mkEnableOption "Starship";
  };

  config = mkIf cfg.enable {
    programs = {
      starship = {
        inherit (cfg) enable;
        enableFishIntegration = fishCfg.enable;
        settings = { };
      };
    };
  };
}

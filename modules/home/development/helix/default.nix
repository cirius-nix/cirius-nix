{ config
, lib
, pkgs
, ...
}:

let
  inherit (lib) mkEnableOption mkIf;

  devCfg = config.cirius.development;
  cfg = devCfg.helix;
in
{
  options.cirius.development.helix = {
    enable = mkEnableOption "helix";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      helix
      helix-gpt
    ];
  };
}

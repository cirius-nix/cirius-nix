{ config
, lib
, pkgs
, ...
}:

let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.cirius.development.zed;
in
{
  options.cirius.development.zed = {
    enable = mkEnableOption "Zed";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      zed
    ];
  };
}

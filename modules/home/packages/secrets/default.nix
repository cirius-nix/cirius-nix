{ config
, pkgs
, lib
, ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.cirius.packages.secrets;
in
{
  options.cirius.packages.secrets = {
    enable = mkEnableOption "secrets";
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [ enpass ];
    };
  };
}

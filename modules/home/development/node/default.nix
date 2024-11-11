{ config
, lib
, pkgs
, ...
}:

let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.cirius.development.node;
in
{
  options.cirius.development.node = {
    enable = mkEnableOption "NodeJS";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      nodejs_22
      corepack_22
    ];
  };
}

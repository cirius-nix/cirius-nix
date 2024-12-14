{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.cirius.development.postman;
in
{
  options.cirius.development.postman = {
    enable = mkEnableOption "postman";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      postman
      newman
    ];
  };
}

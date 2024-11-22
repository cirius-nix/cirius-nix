{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.cirius.development.api-client;
in
{
  options.cirius.development.api-client = {
    enable = mkEnableOption "API Client";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      # insomnia
      hoppscotch
      postman
      newman
    ];
  };
}

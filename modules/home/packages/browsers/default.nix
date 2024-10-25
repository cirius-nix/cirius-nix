{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.cirius.packages.browsers;
in
{
  options.cirius.packages.browsers = {
    enable = mkEnableOption "browsers";
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        floorp
        microsoft-edge
      ];
    };
  };
}

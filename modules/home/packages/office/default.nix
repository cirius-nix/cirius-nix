{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.cirius.packages.office;
in
{
  options.cirius.packages.office = {
    enable = mkEnableOption "office";
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [ libreoffice-qt6-fresh ];
    };
  };
}

{ config
, pkgs
, lib
, ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.cirius.development.db;
in
{
  options.cirius.development.db = {
    enable = mkEnableOption "Database";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      # dbeaver-bin
      mycli
      pgcli
    ];
  };
}

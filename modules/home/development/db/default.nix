{
  config,
  pkgs,
  lib,
  ...
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
      nodePackages.sql-formatter
      less
    ];
    home.file.".myclirc" = {
      text = ''
        [main]

        winder_completion_menu = True
        multi_line = True
        generate_aliases = True
        table_format = fancy_grid
        vi = True
        row_limit = 1000
      '';
    };
    home.file.".config/pgcli/config" = {
      text = ''
        [main]

        winder_completion_menu = True
        multi_line = True
        generate_aliases = True
        table_format = fancy_grid
        vi = True
        row_limit = 1000
      '';
    };
  };
}

{
  config,
  pkgs,
  lib,
  namespace,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.${namespace}.development.db;

in

{
  options.${namespace}.development.db = {
    enable = mkEnableOption "Database";
  };

  config = mkIf cfg.enable {
    ${namespace}.development.cli-utils.fish = {
      interactiveEnvs = {
        PAGER = "${pkgs.less}/bin/less -S";
      };
    };
    home.packages = with pkgs; [
      mycli
      pgcli
      nodePackages.sql-formatter
      less
      jetbrains.datagrip
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

{
  lib,
  namespace,
  config,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    ;
  cfg = config.${namespace}.development.ide.db;

  specificPkgs =
    with pkgs;
    (
      if (!pkgs.stdenv.isDarwin) then
        [
          jetbrains.datagrip
          dbeaver-bin
        ]
      else
        [ ]
    );
in
{
  options.${namespace}.development.ide.db = {
    enable = mkEnableOption "Database";
    # specificPkgs = mkOption {
    #   type = with types; listOf package;
    #   default = [ ];
    #   description = "A list of packages to be installed.";
    # };
  };

  config = mkIf cfg.enable {
    home.packages =
      with pkgs;
      [
        # depedencies
        nodePackages.sql-formatter
        less

        # cli
        mycli
        pgcli
      ]
      ++ specificPkgs;

    home.file = {
      ".myclirc".text = ''
        [main]

        winder_completion_menu = True
        multi_line = True
        generate_aliases = True
        table_format = fancy_grid
        vi = True
        row_limit = 1000
      '';

      ".config/pgcli/config".text = ''
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

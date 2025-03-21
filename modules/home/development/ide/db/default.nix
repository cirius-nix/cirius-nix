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
    # ensure that lib.getExe can find the binary from those names.
    main = lib.${namespace}.mkEnumOption [
      "datagrip"
    ] "datagrip" "Main Database IDE";
  };

  config = mkIf cfg.enable {
    ${namespace}.desktop-environment.hyprland = {
      variables = {
        "mainDBIde" = cfg.main;
      };
      events.onEmptyWorkspaces = {
        "3" = [ "$mainDBIde" ];
      };
      rules.winv2 = {
        center = {
          "" = [ "class:^(.*jetbrains.*)$, title:^(Confirm Exit|Open Project|win424|win201|splash)$" ];
        };
        size = {
          "640 400" = [ "class:^(.*jetbrains.*)$, title:^(splash)$" ];
        };
      };
    };
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

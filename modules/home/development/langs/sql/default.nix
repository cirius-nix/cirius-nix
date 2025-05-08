{
  namespace,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf types;
  inherit (lib.${namespace}) mkOpt mergeL';
  cfg = config.${namespace}.development.langs.sql;
  defaultSQLFormatterSettings = {
    language = "sql";
    tabWidth = 2;
    keywordCase = "upper";
    linesBetweenQueries = 2;
  };
in
{
  options.${namespace}.development.langs.sql = {
    enable = mkEnableOption "enable SQL support";
    sqlFormatter = {
      settings = mkOpt types.attrs { } "SQL formatter settings";
    };
  };

  config = mkIf cfg.enable {
    # https://github.com/sql-formatter-org/sql-formatter/blob/master/docs/language.md
    xdg.configFile."~/.config/sql_formatter.json".text = builtins.toJSON (
      mergeL' defaultSQLFormatterSettings [
        cfg.sqlFormatter.settings
      ]
    );
    home.packages = with pkgs; [
      sqls
      sql-formatter
      sqlfluff
    ];
    programs.nixvim.plugins = {
      # config conform for formatting and linting.
      conform-nvim.settings = {
        formatters = {
          sql_formatter = {
            prepend_args = {
              __raw = ''
                { "-c", vim.fn.expand("~/.config/sql_formatter.json") },
              '';
            };
          };
          sqlfluff = {
            command = lib.getExe pkgs.sqlfluff;
          };
        };
        formatters_by_ft = {
          sql = [
            "sql_formatter"
            "sqlfluff"
          ];
        };
      };
    };
  };
}

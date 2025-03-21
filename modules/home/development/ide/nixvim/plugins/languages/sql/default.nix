{
  namespace,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    ;

  cfg = config.${namespace}.development.ide.nixvim.plugins.languages.sql;
in
{
  options.${namespace}.development.ide.nixvim.plugins.languages.sql = {
    enable = mkEnableOption "Enable SQL Language Server";
  };

  config = mkIf cfg.enable {
    # INFO: definitionn of configuration is defined there.
    # https://github.com/sql-formatter-org/sql-formatter/blob/master/docs/language.md
    xdg.configFile."~/.config/sql_formatter.json".text = ''
      {
        "language": "postgresql",
        "tabWidth": 2,
        "keywordCase": "upper",
        "linesBetweenQueries": 2
      }
    '';

    programs.nixvim.plugins = {
      lsp.servers = {
        # INFO: I disabled 2 servers because it required connection to the
        # database, which I do not intend to do.
        # sqlls = mkEnabled;
        # sqls = mkEnabled;
      };
      conform-nvim.settings = {
        # INFO: custom formatter to be used.
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

        # INFO: use formatter(s).
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

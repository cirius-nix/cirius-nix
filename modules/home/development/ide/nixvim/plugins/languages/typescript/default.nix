{
  namespace,
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption mkOption;
  cfg = config.${namespace}.development.ide.nixvim.plugins.languages.typescript;
in
{
  options.${namespace}.development.ide.nixvim.plugins.languages.typescript = {
    enable = mkEnableOption "TypeScript support";
    enableAngularls = mkEnableOption {
      default = false;
      description = ''
        Enable Angular Language Server.
      '';
    };
    formatTimeout = mkOption {
      type = lib.types.int;
      default = 1000;
      description = ''
        Timeout in milliseconds for formatting TypeScript files.
      '';
    };
  };
  config = mkIf cfg.enable {
    programs.nixvim = {
      plugins = {
        typescript-tools = {
          enable = true;
        };
        lsp = {
          servers = {
            ts_ls = {
              enable = true;
            };
            eslint = {
              enable = true;
            };
            angularls = {
              enable = cfg.enableAngularls;
              filetypes = [
                "html"
                "typescript"
              ];
              rootDir = {
                __raw = ''
                  (function()
                  	local util = require("lspconfig.util")
                  	root_dir = util.root_pattern("angular.json", "project.json")
                  	return root_dir
                  end)()
                '';
              };
            };
          };
        };
      };
    };
  };
}

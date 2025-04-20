{
  config,
  namespace,
  lib,
  ...
}:
let
  cfg = config.${namespace}.development.ide.nixvim.plugins.session;
in
{
  options.${namespace}.development.ide.nixvim.plugins.session = {
    enable = lib.mkEnableOption "Enable session";
  };

  config = lib.mkIf cfg.enable {
    programs.nixvim = {
      opts = {
        sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions";
      };
      plugins = {
        auto-session = {
          enable = true;
          settings = {
            bypass_save_filetypes = [
              "neo-tree"
              "dapui_scopes"
              "dapui_breakpoints"
              "dapui_stacks"
              "dapui_watches"
              "dapui_console"
              "dapui_repl"
            ];
          };
        };
        overseer = {
          enable = true;
        };
      };
    };
  };
}

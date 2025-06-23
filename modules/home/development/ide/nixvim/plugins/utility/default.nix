{
  config,
  namespace,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (config.${namespace}.development.ide.nixvim.plugins) utility;
in
{
  options.${namespace}.development.ide.nixvim.plugins.utility = {
    enable = mkEnableOption "Enable utility plugins";
  };

  config = {
    programs.nixvim = {
      extraPlugins = with pkgs; [ vimPlugins.nvim-window-picker ];
      extraConfigLuaPost = ''
        require 'window-picker'.setup {
          filter_rules = {
            bo = {
              filetype = { 'NvimTree', 'neo-tree', 'notify', 'snacks_notif', 'dapui_scopes', 'dapui_breakpoints', 'dapui_stacks', 'dapui_watches', 'dap-repl', 'dapui_console' },
            },
          },
        }
      '';
    };
  };
}

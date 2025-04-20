{
  namespace,
  config,
  lib,
  ...
}:
let
  cfg = config.${namespace}.development.ide.nixvim.plugins.term;
  inherit (lib) mkIf mkEnableOption;
  inherit (lib.${namespace}.nixvim) mkKeymap;
in
{
  options.${namespace}.development.ide.nixvim.plugins.term = {
    enable = mkEnableOption "Enable terminal in neovim";
  };

  config = mkIf cfg.enable {
    programs.nixvim = {
      plugins = {
        toggleterm = {
          enable = true;
          settings = {
            direction = "float";
            float_opts = {
              border = "curved";
              height = 30;
              width = 130;
            };
          };
        };
      };
      extraConfigLuaPost = ''
        _G.FUNCS.init_or_toggle_term = function()
          vim.cmd([[ ToggleTermToggleAll ]])
          local buffers = vim.api.nvim_list_bufs()
          local toggleterm_exists = false
          for _, buf in ipairs(buffers) do
            local buf_name = vim.api.nvim_buf_get_name(buf)
            if buf_name:find("toggleterm#") then
              toggleterm_exists = true
              break
            end
          end
          if not toggleterm_exists then
            vim.cmd([[ exe 1 . "ToggleTerm" ]])
          end
        end
        _G.FUNCS.set_terminal_keymaps = function()
          local opts = {buffer = 0}
          vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
        end
        vim.cmd('autocmd! TermOpen term://* lua _G.FUNCS.set_terminal_keymaps()')
      '';
      keymaps = [
        (mkKeymap "<leader>\\" "<cmd>lua _G.FUNCS.init_or_toggle_term()<cr>" " Toggle Terminal")
        (mkKeymap "<F5>" "<cmd>lua _G.FUNCS.init_or_toggle_term()<cr>" " Toggle Terminal")
        (mkKeymap "<F6>" "<cmd>TermNew<cr>" " New Terminal")
        (mkKeymap "<F7>" "<cmd>TermSelect<cr>" " Select Terminal")
      ];
    };
  };
}

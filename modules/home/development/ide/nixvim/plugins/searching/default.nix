{
  config,
  namespace,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.${namespace}.nixvim) mkKeymap mkEnabled;
  cfg = config.${namespace}.development.ide.nixvim.plugins.searching;
in
{
  options.${namespace}.development.ide.nixvim.plugins.searching = {
    enable = mkEnableOption "Enable Searching Plugins";

  };
  config = mkIf cfg.enable {
    programs.nixvim = {
      plugins = mkIf cfg.enable {
        nvim-tree = {
          enable = true;
          syncRootWithCwd = true;
          respectBufCwd = true;
          updateFocusedFile = {
            enable = true;
            updateRoot = false;
          };
          renderer.icons.gitPlacement = "after";
          diagnostics.enable = true;
        };
        telescope = {
          enable = true;
          settings = {
            defaults = {
              border = false;
            };
          };
          extensions = {
            fzf-native = mkEnabled;
            ui-select = mkEnabled;
            file-browser = mkEnabled;
            frecency = mkEnabled;
            manix = mkEnabled;
          };
        };
        spectre = {
          enable = true;
          settings = {
            find = {
              # Nixvim will automatically enable `dependencies.sed.enable` (or
              # `sd` respectively).
              cmd = "sed";
            };
            is_block_ui_break = true;
          };
        };
      };
      extraConfigLuaPost = ''
        _G.FUNCS.nvimtree_focus_or_close = function()
          local win = vim.api.nvim_get_current_win()
          if vim.bo.filetype == "NvimTree" then
            vim.api.nvim_win_close(win, true)
          else
            vim.cmd("NvimTreeRefresh")
            vim.cmd("NvimTreeFocus")
          end
        end

        _G.FUNCS.get_selected_text_in_visual_mode = function()
          vim.cmd('noau normal! "vy"')
          local text = vim.fn.getreg("v")
          vim.fn.setreg("v", {})

          text = string.gsub(text, "\n", "")
          if #text > 0 then
            return text
          else
            return ""
          end
        end

        _G.FUNCS.search_selected_text_in_visual_mode = function()
          local text = _G.FUNCS.get_selected_text_in_visual_mode()
          require("telescope.builtin").live_grep({ default_text = text })
        end
      '';
      keymaps = [
        # NvimTree
        (mkKeymap "<leader>e" "<cmd>lua _G.FUNCS.nvimtree_focus_or_close()<cr>" "ToggleNvimTree")
        # Spectre
        (mkKeymap "<leader>s" "<cmd>lua require('spectre').toggle()<cr>" "SearchReplace")
        (mkKeymap "<leader>s" "<cmd>lua require('spectre').open_visual()<cr>" {
          mode = [ "v" ];
          options = {
            silent = true;
            noremap = true;
            nowait = true;
            desc = "SearchReplace";
          };
        })
        # Telescope
        (mkKeymap "<leader>ff" "<cmd>Telescope find_files<cr>" "FindFiles")
        # file browser fF
        (mkKeymap "<leader>fF" "<cmd>Telescope file_browser<cr>" "FileBrowser")
        # live grep fs
        (mkKeymap "<leader>fs" "<cmd>Telescope live_grep<cr>" "LiveGrep")
        # live grep fs in visual mode
        (mkKeymap "<leader>fs" "<cmd>lua _G.FUNCS.search_selected_text_in_visual_mode()<cr>" {
          mode = [ "v" ];
          options = {
            silent = true;
            noremap = true;
            nowait = true;
            desc = "LiveGrep";
          };
        })
        # buffers fb
        (mkKeymap "<leader>fb" "<cmd>Telescope buffers<cr>" "Buffers")
        # resume fr
        (mkKeymap "<leader>fr" "<cmd>Telescope resume<cr>" "Resume")
        # help help
        (mkKeymap "<leader>fh" "<cmd>Telescope help_tags<cr>" "Help")
        # TodoTrouble ft
        (mkKeymap "<leader>ft" "<cmd>TodoTrouble<cr>" "TodoTrouble")
      ];
    };
  };
}

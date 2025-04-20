{
  config,
  namespace,
  lib,
  pkgs,
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
      extraPlugins = with pkgs; [ vimPlugins.nvim-window-picker ];
      plugins = mkIf cfg.enable {
        nerdy = {
          enable = true;
          enableTelescope = true;
        };
        neo-tree = {
          enable = true;
          filesystem = {
            useLibuvFileWatcher = true;
            followCurrentFile = {
              enabled = true;
            };
          };
          window.mappings = {
            "<c-v>" = "vsplit_with_window_picker";
            "<c-x>" = "split_with_window_picker";
            "x" = "cut_to_clipboard";
            "c" = "copy_to_clipboard";
            "<cr>" = "open_with_window_picker";
            "o" = "toggle_node";
            "e" = {
              command = "toggle_preview";
              config = {
                use_float = true;
              };
            };
          };
        };
        # nvim-tree = {
        #   enable = true;
        #   syncRootWithCwd = true;
        #   respectBufCwd = true;
        #   updateFocusedFile = {
        #     enable = true;
        #     updateRoot = false;
        #   };
        #   renderer.icons.gitPlacement = "after";
        #   diagnostics.enable = true;
        # };
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
      extraConfigLuaPre = ''
        require 'window-picker'.setup {
          filter_rules = {
            bo = {
              filetype = { 'NvimTree', 'neo-tree', 'notify', 'snacks_notif', 'dapui_scopes', 'dapui_breakpoints', 'dapui_stacks', 'dapui_watches', 'dap-repl', 'dapui_console' },
            },
          },
        }
      '';
      extraConfigLuaPost = ''
        _G.FUNCS.neotree_focus_or_close = function()
          local win = vim.api.nvim_get_current_win()
          if vim.bo.filetype == "neo-tree" then
            vim.api.nvim_win_close(win, true)
          else
            if _G.FUNCS.check_dapui_visible() then
              vim.cmd("Neotree focus position=float")
              return
            end
          --   vim.cmd("NvimTreeRefresh")
            vim.cmd("Neotree focus position=left")
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
        (mkKeymap "<leader>e" "<cmd>lua _G.FUNCS.neotree_focus_or_close()<cr>" "󰙅 Toggle Explorer")
        # Spectre
        (mkKeymap "<leader>s" "<cmd>lua require('spectre').toggle()<cr>" " Search & Replace")
        (mkKeymap "<leader>s" "<cmd>lua require('spectre').open_visual()<cr>" {
          mode = [ "v" ];
          options = {
            silent = true;
            noremap = true;
            nowait = true;
            desc = " Search & Replace";
          };
        })
        # Telescope
        (mkKeymap "<leader>ff" "<cmd>Telescope find_files<cr>" " Find File")
        # live grep fs
        (mkKeymap "<leader>fs" "<cmd>Telescope live_grep<cr>" "󱄽 Search String")
        # live grep fs in visual mode
        (mkKeymap "<leader>fs" "<cmd>lua _G.FUNCS.search_selected_text_in_visual_mode()<cr>" {
          mode = [ "v" ];
          options = {
            silent = true;
            noremap = true;
            nowait = true;
            desc = "󱄽 Search String";
          };
        })
        # buffers fb
        (mkKeymap "<leader>fb" "<cmd>Telescope buffers<cr>" " Buffers")
        # resume fr
        (mkKeymap "<leader>fr" "<cmd>Telescope resume<cr>" " Resume")
        # help help
        (mkKeymap "<leader>fh" "<cmd>Telescope help_tags<cr>" "󰘥 Help")
        # TodoTrouble ft
        (mkKeymap "<leader>ft" "<cmd>TodoTrouble<cr>" " TODO")
        (mkKeymap "<leader>fi" "<cmd>Telescope nerdy<cr>" "󰲍 Icon picker")
      ];
    };
  };
}

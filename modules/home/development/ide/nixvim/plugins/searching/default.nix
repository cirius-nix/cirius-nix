{
  config,
  namespace,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.${namespace}.nixvim) mkKeymap;

  inherit (config.${namespace}.development.ide.nixvim.plugins) searching;
in
{
  options.${namespace}.development.ide.nixvim.plugins.searching = {
    enable = mkEnableOption "Enable Searching Plugins";
  };
  config = mkIf searching.enable {
    programs.nixvim = {
      plugins = {
        grug-far = {
          enable = true;
          settings = {
            debounceMs = 1000;
            engine = "ripgrep";
            engines = {
              ripgrep = {
                path = "${pkgs.ripgrep}/bin/rg";
                showReplaceDiff = true;
              };
            };
            maxSearchMatches = 2000;
            maxWorkers = 8;
            minSearchChars = 1;
            normalModeSearch = false;
          };
        };
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
        telescope = {
          enable = true;
          settings = {
            defaults = {
              border = false;
            };
          };
          extensions = {
            fzf-native.enable = true;
            ui-select.enable = true;
            frecency.enable = true;
            manix.enable = true;
          };
        };
      };

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
            vim.cmd("Neotree focus position=left")
          end
        end
      '';
      keymaps = [
        (mkKeymap "<leader>e" "<cmd>lua _G.FUNCS.neotree_focus_or_close()<cr>" "󰙅 Toggle Explorer")
        # Telescope
        (mkKeymap "<leader>ff" "<cmd>Telescope find_files<cr>" " Find File")
        # live grep fs
        (mkKeymap "<leader>fs" "<cmd>GrugFar<cr>" "󱄽 Search String")
        # live grep fs in visual mode
        (mkKeymap "<leader>fs" ":GrugFar<cr>" {
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
        (mkKeymap "<leader>ft" "<cmd>TodoTrouble<cr>" " TODO")
        (mkKeymap "<leader>fi" "<cmd>Telescope nerdy<cr>" "󰲍 Icon picker")
      ];
    };
  };
}

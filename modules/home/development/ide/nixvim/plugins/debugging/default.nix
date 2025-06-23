{
  namespace,
  lib,
  config,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    ;

  cfg = config.${namespace}.development.ide.nixvim.plugins.debugging;
  inherit (lib.${namespace}.nixvim) mkKeymap;
in
{
  options.${namespace}.development.ide.nixvim.plugins.debugging = {
    enable = mkEnableOption "Enable debugging plugins";
  };

  config = mkIf cfg.enable {
    programs = {
      nixvim = {
        plugins = {
          trouble = {
            enable = true;
            settings = {
              auto_close = true;
              auto_jump = false;
              auto_preview = true;
              auto_refresh = true;
            };
          };
          dap = {
            enable = true;
            adapters = {
              servers = { };
            };
            configurations = {
              go = [ ];
            };
          };
          cmp-dap = {
            enable = true;
          };
          dap-virtual-text = {
            enable = true;
          };
          dap-go = {
            enable = true;
          };
          dap-ui = {
            enable = true;
          };
        };
        keymaps = [
          (mkKeymap "<leader>dd" "<cmd>DapContinue<cr>" " Continue")
          (mkKeymap "<leader>do" "<cmd>DapStepOver<cr>" " StepOver")
          (mkKeymap "<leader>dr" "<cmd>DapRerun<cr>" " Rerun")
          (mkKeymap "<leader>db" "<cmd>DapToggleBreakpoint<cr>" " Toggle Breakpoints")
          (mkKeymap "<leader>dB" "<cmd>lua require('dap').clear_breakpoints()<cr>" " Clear Breakpoints")
          (mkKeymap "<leader>dc" "<cmd>DapContinue<cr>" " Continue")
          (mkKeymap "<leader>ds" "<cmd>DapStepInto<cr>" " Step Into")
          (mkKeymap "<leader>dS" "<cmd>DapStepOut<cr>" " StepOut")
          (mkKeymap "<leader>dD" "<cmd>DapTerminate<cr>" "󰈆 Terminate")
          (mkKeymap "<leader>fd" "<cmd>lua _G.FUNCS.dapui_focus_or_close()<cr>" " Toggle Dap UI")
        ];
        extraConfigLua = ''
          local dapUIFileTypes = { "dapui_scopes", "dapui_breakpoints", "dapui_stacks", "dapui_watches", "dapui_console", "dap-repl" }

          _G.FUNCS.check_dapui_visible = function()
            local dapFiletypeSet = {}
            for _, ft in ipairs(dapUIFileTypes) do
              dapFiletypeSet[ft] = true
            end
            for _, win in ipairs(vim.api.nvim_list_wins()) do
              local buf = vim.api.nvim_win_get_buf(win)
              local ft = vim.api.nvim_buf_get_option(buf, "filetype")
              if dapFiletypeSet[ft] then
                return true
              end
            end
            return false
          end

          _G.FUNCS.check_dapui_focused = function()
            local dapui = require("dapui")
            -- if focus dapUI -> close dapUI
            for _, ft in ipairs(dapUIFileTypes) do
              if vim.bo.filetype == ft then
                -- dapui.close()
                return true
              end
            end
            return false
          end

          _G.FUNCS.dapui_focus_or_close = function()
            local dapui = require("dapui")
            if _G.FUNCS.check_dapui_focused() then
              dapui.close()
              return
            end


            -- dapUI does not exists or not focused
            -- close neotree first
            for _, win in ipairs(vim.api.nvim_list_wins()) do
              local buf = vim.api.nvim_win_get_buf(win)
              local ft = vim.api.nvim_buf_get_option(buf, "filetype")
              if ft == 'neo-tree' then
                vim.cmd("Neotree close")
              end
            end

            -- open dapui if not exists
            dapui.open()
            -- focus the first openning dapui_scopes
            vim.defer_fn(function()
              for _, win in ipairs(vim.api.nvim_list_wins()) do
                local buf = vim.api.nvim_win_get_buf(win)
                local ft = vim.api.nvim_buf_get_option(buf, "filetype")
                if ft == "dapui_scopes" then
                  vim.api.nvim_set_current_win(win)
                  break
                end
              end
            end, 100)
          end


          _G.FUNCS.switch_dapui_window = function()
            local dapui_filetypes = {
              ["dapui_scopes"] = true,
              ["dapui_breakpoints"] = true,
              ["dapui_stacks"] = true,
              ["dapui_watches"] = true,
              ["dapui_console"] = true,
              ["dap-repl"] = true,
            }

            local current_win = vim.api.nvim_get_current_win()
            local current_buf = vim.api.nvim_win_get_buf(current_win)
            local current_ft = vim.api.nvim_buf_get_option(current_buf, "filetype")

            -- Only act if current window is DAP UI
            if not dapui_filetypes[current_ft] then
              return
            end

            local wins = vim.api.nvim_list_wins()
            local dapui_wins = {}

            -- Collect all DAP UI windows
            for _, win in ipairs(wins) do
              local buf = vim.api.nvim_win_get_buf(win)
              local ft = vim.api.nvim_buf_get_option(buf, "filetype")
              if dapui_filetypes[ft] then
                table.insert(dapui_wins, win)
              end
            end

            -- Sort dapui windows by window ID for consistency
            table.sort(dapui_wins)

            -- Find current index
            local current_index = nil
            for i, win in ipairs(dapui_wins) do
              if win == current_win then
                current_index = i
                break
              end
            end

            -- Move to next window (circular)
            if current_index then
              local next_index = (current_index % #dapui_wins) + 1
              vim.api.nvim_set_current_win(dapui_wins[next_index])
            end
          end


          vim.api.nvim_create_autocmd("FileType", {
            pattern = {
              "dapui_scopes",
              "dapui_breakpoints",
              "dapui_stacks",
              "dapui_watches",
              "dapui_console",
              "dap-repl",
            },
            callback = function()
              vim.keymap.set("n", "<Tab>", function()
                _G.FUNCS.switch_dapui_window()
              end, { buffer = true, noremap = true, silent = true })
            end,
          })
        '';

        extraConfigLuaPost = ''
          require("telescope").load_extension("lazygit")

          local dap, dapui = require("dap"), require("dapui")
          dap.listeners.after.event_initialized["dapui_config"] = function()
            dapui.open()
          end

          dap.listeners.before.event_terminated["dapui_config"] = function()
            dapui.close()
          end

          dap.listeners.before.event_exited["dapui_config"] = function()
            dapui.close()
          end
        '';
      };
    };
  };
}

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
          (mkKeymap "<leader>dd" "<cmd>DapContinue<cr>" "Continue")
          (mkKeymap "<leader>do" "<cmd>DapStepOver<cr>" "StepOver")
          (mkKeymap "<leader>dr" "<cmd>DapRerun<cr>" "Rerun")
          (mkKeymap "<leader>dt" "<cmd>DapToggleBreakpoint<cr>" "ToggleBreakpoint")
          (mkKeymap "<leader>db" "<cmd>DapToggleBreakpoint<cr>" "ToggleBreakpoint")
          (mkKeymap "<leader>dB" "<cmd>lua require 'dap'.clear_breakpoints()<cr>" "ClearBreakpoints")
          (mkKeymap "<leader>dc" "<cmd>DapContinue<cr>" "Continue")
          (mkKeymap "<leader>ds" "<cmd>DapStepInto<cr>" "StepInto")
          (mkKeymap "<leader>dS" "<cmd>DapStepOut<cr>" "StepOut")
          (mkKeymap "<leader>dD" "<cmd>DapTerminate<cr>" "Terminate")
          (mkKeymap "<leader>dT" "<cmd>lua require 'dap'.clear_breakpoints()<cr>" "ClearBreakpoints")
          (mkKeymap "<leader>fd" "<cmd>DapUiToggle<cr>" "ToggleDapUI")
        ];
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

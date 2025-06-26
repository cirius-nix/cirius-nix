{
  lib,
  namespace,
  config,
  ...
}:
let
  cfg = config.${namespace}.development.ide.nixvim;
  inherit (lib) mkIf;
in
{
  config = mkIf cfg.enable {
    programs.nixvim = {
      plugins = {
        nui.enable = false;
        # Editor
        sleuth = {
          enable = true;
          settings = { };
        };
        render-markdown = {
          enable = true;
          settings = { };
        };
        treesitter = {
          enable = true;
          settings = {
            highlight = {
              enable = true;
            };
            indent = {
              enable = true;
            };
          };
        };
        mini = {
          enable = true;
          modules = {
            comment = { };
            pairs = { };
          };
        };
        typescript-tools = {
          enable = true;
          settings = {
            settings = {
              separate_diagnostic_server = true;
              publish_diagnostic_on = "insert_leave";
              tsserver_max_memory = "auto";
              tsserver_locale = "en";
              complete_function_calls = false;
              include_completions_with_insert_text = true;
              code_lens = "off";
              disable_member_code_lens = true;
              jsx_close_tag = {
                enable = false;
                filetypes = [
                  "javascriptreact"
                  "typescriptreact"
                ];
              };
            };
          };
        };
        snacks = {
          enable = false;
          settings = { };
        };
        fidget = {
          enable = false;
          settings = {
            notification.filter = "info";
            poll_rate = 300;
          };
        };
        colorizer.enable = true;
        web-devicons.enable = true;
        rainbow-delimiters.enable = true;
        todo-comments = {
          enable = true;
          settings = {
            signs = false;
          };
        };
        wilder = {
          enable = true;
        };
        lualine.enable = true;
        which-key = {
          enable = true;
          settings = {
            icons.mappings = false;
            icons.separator = " ";
            icons.group = " ";
            preset = "modern";
            delay = 0;
            show_help = false;
            spec = [
              {
                __unkeyed = "<leader>f";
                group = " Find";
              }
              {
                __unkeyed = "<leader>d";
                group = " Debugging";
              }
              {
                __unkeyed = "<leader>l";
                group = " LSP";
              }
              {
                __unkeyed = "<leader>t";
                group = " Testing";
              }
              {
                __unkeyed = "<leader>e";
                group = "󰙅 File Explorer";
              }
              {
                __unkeyed = "<leader>g";
                group = " Git";
              }
              {
                __unkeyed = "<leader>a";
                group = " AI";
              }
              {
                __unkeyed = "<leader>w";
                group = " Window";
              }
              {
                __unkeyed = "<leader>aa";
                desc = "󰺴 Ask";
              }
              {
                __unkeyed = "<leader>ad";
                desc = " Toggle Debug";
              }
              {
                __unkeyed = "<leader>af";
                desc = "󰽎 Focus";
              }
              {
                __unkeyed = "<leader>ah";
                desc = " Hint";
              }
              {
                __unkeyed = "<leader>ar";
                desc = " Refresh";
              }
              {
                __unkeyed = "<leader>aR";
                desc = "󰳏 Repo";
              }
              {
                __unkeyed = "<leader>as";
                desc = " Toggle Suggestions";
              }
              {
                __unkeyed = "<leader>at";
                desc = " Toggle";
              }
              {
                __unkeyed = "<leader>a?";
                desc = "󰳇 Models";
              }
              {
                __unkeyed = "<leader>la";
                desc = " Code actions";
              }
              {
                __unkeyed = "<leader>ld";
                desc = " Go to definition";
              }
              {
                __unkeyed = "<leader>lD";
                desc = " Go to type definition";
              }
              {
                __unkeyed = "<leader>lf";
                desc = "󰮗 Find";
              }
              {
                __unkeyed = "<leader>lF";
                desc = "󰴑 Format file";
              }
              {
                __unkeyed = "<leader>lo";
                desc = "󰧮 Outline";
              }
              {
                __unkeyed = "<leader>lr";
                desc = "󰑕 Rename";
              }
            ];
          };
        };
      };
    };
  };
}

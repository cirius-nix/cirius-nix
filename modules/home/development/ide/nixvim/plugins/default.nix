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
        nui.enable = true;
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
        # https://gpanders.com/blog/whats-new-in-neovim-0-11/#more-default-mappings
        # grn in Normal mode maps to vim.lsp.buf.rename()
        # grr in Normal mode maps to vim.lsp.buf.references()
        # gri in Normal mode maps to vim.lsp.buf.implementation()
        # gO in Normal mode maps to vim.lsp.buf.document_symbol() (this is analogous to the gO mappings in help buffers and :Man page buffers to show a “table of contents”)
        # gra in Normal and Visual mode maps to vim.lsp.buf.code_action()
        # CTRL-S in Insert and Select mode maps to vim.lsp.buf.signature_help()
        # [d and ]d move between diagnostics in the current buffer ([D jumps to the first diagnostic, ]D jumps to the last)
        lsp = {
          enable = true;
          keymaps = {
            diagnostic = {
              "]e" = "goto_next";
              "[e" = "goto_prev";
            };
            # lspBuf = {
            #   gD = "references";
            #   gd = "definition";
            #   gi = "implementation";
            #   gt = "type_definition";
            # };
            extra = [
              {
                action = "<cmd>Lspsaga hover_doc<cr>";
                key = "K";
              }
              {
                action = "<cmd>lua vim.lsp.buf.format({ async = true })<cr>";
                key = "<leader>lF";
              }
              {
                action = "<cmd>Lspsaga goto_type_definition<cr>";
                key = "<leader>lD";
              }
              # gra in Normal and Visual mode maps to vim.lsp.buf.code_action()
              {
                action = "<cmd>Lspsaga code_action<cr>";
                key = "<leader>la";
              }
              {
                action = "<cmd>Lspsaga goto_definition<cr>";
                key = "<leader>ld";
              }
              # grr in Normal mode maps to vim.lsp.buf.references()
              {
                action = "<cmd>Lspsaga finder<cr>";
                key = "<leader>lf";
              }
              {
                action = "<cmd>Lspsaga finder<cr>";
                key = "grr";
              }
              # gO in Normal mode maps to vim.lsp.buf.document_symbol() (this is analogous to the gO mappings in help buffers and :Man page buffers to show a “table of contents”)
              {
                action = "<cmd>Telescope lsp_document_symbols<cr>";
                key = "<leader>lo";
              }
              # grn in Normal mode maps to vim.lsp.buf.rename()
              {
                action = "<cmd>Lspsaga rename mode=n<cr>";
                key = "<leader>lr";
              }
              {
                action = "<cmd>Lspsaga rename mode=n<cr>";
                key = "grn";
              }
            ];
          };
          servers = {
            terraformls.enable = true;
          };
        };
        lspsaga = {
          enable = true;
          beacon = {
            enable = true;
            frequency = 7;
          };
          finder = {
            keys = {
              toggleOrOpen = "<CR>";
              vsplit = "<C-v>";
              split = "<C-x>";
              quit = "q";
            };
          };
        };
        schemastore = {
          enable = true;
          json = {
            enable = true;
          };
          yaml = {
            enable = true;
          };
        };
        luasnip.enable = true;
        snacks = {
          enable = false;
          settings = { };
        };
        fidget = {
          enable = true;
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
        trouble = {
          enable = true;
          settings = {
            auto_close = true;
          };
        };
        lualine.enable = true;
        bufferline.enable = true;
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
        lspkind = {
          enable = true;
          mode = "symbol";
          extraOptions = {
            fields = [
              "abbr"
              "kind"
              "menu"
            ];
          };
          cmp = {
            enable = true;
            ellipsisChar = "..";
            maxWidth = 50;
          };
        };
      };
    };
  };
}
{
  lib,
  namespace,
  config,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (config.${namespace}.development.ide) nixvim;
in
{
  config = mkIf nixvim.enable {
    programs.nixvim = {
      plugins = {
        none-ls = {
          enable = true;
          settings = { };
          sources = {
            code_actions = {
            };
          };
        };
        lsp = {
          enable = true;
          # TODO: move this to global keybindings.nix
          keymaps = {
            diagnostic = {
              "]e" = "goto_next";
              "[e" = "goto_prev";
            };
            extra = [
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
              {
                action = "<cmd>Trouble diagnostics<cr>";
                key = "<leader>le";
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
      };
    };
  };
}

{ config
, lib
, pkgs
, ...
}:

let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.cirius.development.nixvim;

  extraCfgLua = import ./nvim/extra-config.nix;
in
{
  options.cirius.development.nixvim = {
    enable = mkEnableOption "nixvim";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs;[ nodejs_22 ];
    programs.nixvim = {
      inherit (cfg) enable;
      colorschemes.vscode.enable = true;
      plugins = {
        telescope = {
          enable = true;
        };
        undotree = {
          enable = true;
          settings = {
            autoOpenDiff = true;
            focusOnToggle = true;
          };
        };
        treesitter = { enable = true; };
        nix.enable = true;
        nix-develop.enable = true;
        nvim-tree = {
          enable = true;
          syncRootWithCwd = true;
          respectBufCwd = true;
          updateFocusedFile = {
            enable = true;
            updateRoot = true;
          };
        };
        cmp-nvim-lsp.enable = true;
        luasnip.enable = true;
        lualine.enable = true;
        bufferline.enable = true;
        lsp = {
          enable = true;
          keymaps = {
            diagnostic = {
              "]e" = "goto_next";
              "[e" = "goto_prev";
            };
            lspBuf = {
              gD = "references";
              gd = "definition";
              gi = "implementation";
              gt = "type_definition";
            };
            extra = [
              { action = "<cmd>Lspsaga hover_doc<cr>"; key = "K"; }
              { action = "<cmd>Lspsaga goto_type_definition<cr>"; key = "<leader>lD"; }
              { action = "<cmd>Lspsaga code_action<cr>"; key = "<leader>la"; }
              { action = "<cmd>Lspsaga goto_definition<cr>"; key = "<leader>ld"; }
              { action = "<cmd>Lspsaga finder<cr>"; key = "<leader>lf"; }
              { action = "<cmd>Lspsaga outline<cr>"; key = "<leader>lo"; }
              { action = "<cmd>Lspsaga rename mode=n<cr>"; key = "<leader>lr"; }
            ];
          };
          servers = {
            nil-ls.enable = true;
            nixd.enable = true;
            gopls.enable = true;
            golangci-lint-ls.enable = true;
            lua-ls.enable = true;
            jsonls.enable = true;
            terraformls.enable = true;
            yamlls = {
              enable = true;
              extraOptions = {
                settings = {
                  yaml = {
                    schemas = {
                      kubernetes = "'*.yaml";
                      "http://json.schemastore.org/github-workflow" = ".github/workflows/*";
                      "http://json.schemastore.org/github-action" = ".github/action.{yml,yaml}";
                      "https://json.schemastore.org/dependabot-v2" = ".github/dependabot.{yml,yaml}";
                      "https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json" = "*docker-compose*.{yml,yaml}";
                    };
                  };
                };
              };
            };
          };
        };
        lspsaga = {
          enable = true;
          beacon = {
            enable = true;
            frequency = 7;
          };
        };
        schemastore = {
          enable = true;
          json = { enable = true; };
          yaml = { enable = true; };
        };
        copilot-lua = {
          suggestion = { enabled = false; };
          panel = { enabled = false; };
          copilotNodeCommand = "${pkgs.nodejs_22}/bin/node";
        };
        copilot-cmp.enable = true;
        cmp = {
          enable = true;
          autoEnableSources = true;
          cmdline = {
            "/" = {
              mapping = { __raw = "cmp.mapping.preset.cmdline()"; };
              sources = [{ name = "buffer"; }];
            };
            ":" = {
              mapping = { __raw = "cmp.mapping.preset.cmdline()"; };
              sources = [
                { name = "path"; }
                { name = "cmdline"; option = { ignore_cmds = [ "Man" "!" ]; }; }
              ];
            };
          };
          settings = {
            preselect = "cmp.PreselectMode.Item";
            snippet = { expand = "luasnip"; };
            formatting = { fields = [ "kind" "abbr" "menu" ]; };
            performance = {
              debounce = 60;
              fetchingTimeout = 200;
              maxViewEntries = 30;
            };
            mapping = {
              "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
              "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
              "<C-e>" = "cmp.mapping.abort()";
              "<C-Space>" = "cmp.mapping.complete()";
              "<CR>" = "cmp.mapping.confirm({ select = true })";
            };
            sources = [
              { name = "nvim_lsp"; }
              { name = "copilot"; }
              { name = "nvim_lsp_signature_help"; }
              { name = "luasnip"; keywordLength = 3; }
              { name = "path"; }
              { name = "buffer"; }
            ];
          };
          filetype = {
            lua = {
              sources = [
                { name = "nvim_lsp"; }
                { name = "nvim_lua"; }
              ];
            };
          };
        };
        lspkind = {
          enable = true;
          cmp = {
            enable = true;
          };
          symbolMap = {
            Copilot = " ";
          };
          extraOptions = {
            maxwidth = 50;
            ellipsis_char = "...";
          };
        };
        lsp-format = {
          enable = true;
          lspServersToEnable = "all";
        };
        none-ls = {
          enable = true;
          enableLspFormat = true;
        };
        which-key = {
          enable = true;
        };
        mini = {
          enable = true;
          modules = {
            comment = { };
            pairs = { };
          };
        };
      };
      opts = import ./nvim/options.nix;
      keymaps = import ./nvim/keymaps.nix;
      clipboard.register = "unnamedplus";
      globals = {
        mapleader = " ";
        maplocalleader = "\\";
        loaded_netrw = 1;
        loaded_netrwPlugin = 1;
      };
      inherit (extraCfgLua) extraConfigLua;
      inherit (extraCfgLua) extraConfigLuaPre;
      inherit (extraCfgLua) extraConfigLuaPost;
    };
  };
}

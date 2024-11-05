{ pkgs, ... }:
let
  debugger = {
    dap = {
      enable = true;
      adapters = {
        servers = {};
      };
    };
  };
  testing = {
    neotest.enable = true;
  };
  git = {
    gitsigns = {
      enable = true;
      settings = {
        current_line_blame = true;
        trouble = true;
      };
    };
  };
  ui = {
    rainbow-delimiters.enable = true;
    todo-comments.enable = true;
    zen-mode = {
      enable = true;
      settings = {
        on_close = ''
          function()
            require("gitsigns.actions").toggle_current_line_blame()
            vim.cmd('IBLEnable')
            vim.opt.relativenumber = true
            vim.opt.signcolumn = "yes:2"
            require("gitsigns.actions").refresh()
          end
        '';
        on_open = ''
          function()
            require("gitsigns.actions").toggle_current_line_blame()
            vim.cmd('IBLDisable')
            vim.opt.relativenumber = false
            vim.opt.signcolumn = "no"
            require("gitsigns.actions").refresh()
          end
        '';
        plugins = {
          gitsigns = {
            enabled = true;
          };
          options = {
            enabled = true;
            ruler = false;
            showcmd = false;
          };
          tmux = {
            enabled = false;
          };
          twilight = {
            enabled = false;
          };
        };
        window = {
          backdrop = 0.95;
          height = 1;
          options = {
            signcolumn = "no";
          };
          width = 0.8;
        };
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
    dressing.enable = true;
    lualine.enable = true;
    bufferline.enable = true;
    which-key.enable = true;
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
  };
  workspace = {
    telescope = {
      enable = true;
    };
  };
  editor = {
    undotree = {
      enable = true;
      settings = {
        autoOpenDiff = true;
        focusOnToggle = true;
      };
    };
    treesitter = { enable = true; };
    mini = {
      enable = true;
      modules = {
        comment = { };
        pairs = { };
      };
    };
    nvim-tree = {
      enable = true;
      syncRootWithCwd = true;
      respectBufCwd = true;
      updateFocusedFile = {
        enable = true;
        updateRoot = true;
      };
    };
  };
  lsp = {
    nix.enable = true;
    nix-develop.enable = true;
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
          { action = "<cmd>TroubleToggle document_diagnostics<cr>"; key = "<leader>lx"; }
          { action = "<cmd>TroubleToggle workspace_diagnostics<cr>"; key = "<leader>lx"; }
        ];
      };
      servers = {
        nil-ls.enable = true;
        nixd.enable = true;
        gopls.enable = true;
        lua-ls.enable = true;
        jsonls.enable = true;
        terraformls.enable = true;
        tsserver.enable = true;
        tailwindcss.enable = true;
        eslint.enable = true;
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
      json = { enable = true; };
      yaml = { enable = true; };
    };
    copilot-lua = {
      suggestion = { enabled = false; };
      panel = { enabled = false; };
      copilotNodeCommand = "${pkgs.nodejs_22}/bin/node";
    };
    copilot-cmp.enable = true;
    luasnip.enable = true;
    cmp_luasnip.enable = true;
    cmp-dap.enable = true;
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
        formatting = { fields = [ "kind" "abbr" "menu" ]; };
        experimental = {
          ghostText = true;
        };
        performance = {
          debounce = 60;
          fetchingTimeout = 200;
          maxViewEntries = 30;
        };
        snippet = {
          expand = ''
            function(args)
              require'luasnip'.lsp_expand(args.body)
            end
          '';
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
          { name = "luasnip"; keywordLength = 3; }
          { name = "copilot"; }
          { name = "nvim_lsp_signature_help"; }
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

    lsp-format = {
      enable = true;
      lspServersToEnable = "all";
    };
    none-ls = {
      enable = true;
      enableLspFormat = true;
      sources = {
        code_actions = {
          statix.enable = true;
          gomodifytags.enable = true;
          impl.enable = true;
        };
        completion = { };
        diagnostics = {
          golangci_lint.enable = true;
        };
        formatting = {
          goimports.enable = true;
          prettier = {
            enable = true;
            disableTsServerFormatter = true;
          };
        };
      };
    };
  };
  plugins = ui // workspace // editor // lsp // git // testing // debugger;
in
plugins


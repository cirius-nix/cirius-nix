{ pkgs, lib, ... }:
{
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
        {
          action = "<cmd>Lspsaga code_action<cr>";
          key = "<leader>la";
        }
        {
          action = "<cmd>Lspsaga goto_definition<cr>";
          key = "<leader>ld";
        }
        {
          action = "<cmd>Lspsaga finder<cr>";
          key = "<leader>lf";
        }
        {
          action = "<cmd>Telescope lsp_document_symbols<cr>";
          key = "<leader>lo";
        }
        {
          action = "<cmd>Telescope lsp_workspace_symbols<cr>";
          key = "<leader>lO";
        }
        {
          action = "<cmd>Lspsaga rename mode=n<cr>";
          key = "<leader>lr";
        }
        {
          action = "<cmd>TroubleToggle document_diagnostics<cr>";
          key = "<leader>lx";
        }
        {
          action = "<cmd>TroubleToggle workspace_diagnostics<cr>";
          key = "<leader>lx";
        }
      ];
    };
    servers = {
      nil_ls.enable = true;
      nixd.enable = true;
      gopls.enable = true;
      lua_ls.enable = true;
      jsonls.enable = true;
      terraformls.enable = true;
      tsserver.enable = true;
      tailwindcss.enable = true;
      eslint.enable = true;
      sqls.enable = true;
      # prismals.enable = true;
      html.enable = true;
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
    json = {
      enable = true;
    };
    yaml = {
      enable = true;
    };
  };
  luasnip.enable = true;
  cmp_luasnip.enable = true;
  cmp-dap.enable = true;
  cmp-buffer.enable = true;
  cmp-nvim-lsp.enable = true;
  cmp-path = {
    enable = true;
  };
  cmp = {
    enable = true;
    autoEnableSources = true;
    cmdline = {
      "/" = {
        mapping = {
          __raw = "cmp.mapping.preset.cmdline()";
        };
        sources = [ { name = "buffer"; } ];
      };
      ":" = {
        mapping = {
          __raw = "cmp.mapping.preset.cmdline()";
        };
        sources = [
          { name = "path"; }
          {
            name = "cmdline";
            option = {
              ignore_cmds = [
                "Man"
                "!"
              ];
            };
          }
        ];
      };
    };
    settings = {
      preselect = "cmp.PreselectMode.Item";
      experimental = {
        ghost_test = true;
      };
      formatting = {
        fields = [
          "kind"
          "abbr"
          "menu"
        ];
      };
      experimental = {
        ghostText = true;
      };
      window = {
        completion = {
          scrollbar = false;
          sidePadding = 0;
          border = "rounded";
        };
        settings.documentation = {
          border = "rounded";
        };
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
        {
          name = "luasnip";
          keywordLength = 3;
        }
        { name = "codeium"; }
        {
          name = "buffer";
          option.get_bufnrs.__raw = "vim.api.nvim_list_bufs";
        }
        { name = "nvim_lsp_signature_help"; }
        { name = "path"; }
        { name = "buffer"; }
      ];
    };
  };
  conform-nvim = {
    enable = true;

    settings = {
      format_on_save = # Lua
        ''
          function(bufnr)
            if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
              return
            end

            if slow_format_filetypes[vim.bo[bufnr].filetype] then
              return
            end

            local function on_format(err)
              if err and err:match("timeout$") then
                slow_format_filetypes[vim.bo[bufnr].filetype] = true
              end
            end

            return { timeout_ms = 200, lsp_fallback = true }, on_format
           end
        '';

      format_after_save = # Lua
        ''
          function(bufnr)
            if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
              return
            end

            if not slow_format_filetypes[vim.bo[bufnr].filetype] then
              return
            end

            return { lsp_fallback = true }
          end
        '';
      formatters_by_ft = {
        go = [
          "goimports"
          "goimports-reviser"
        ];
        bash = [
          "shellcheck"
          "shellharden"
          "shfmt"
        ];
        bicep = [ "bicep" ];
        c = [ "clang_format" ];
        cmake = [ "cmake-format" ];
        css = [ "stylelint" ];
        fish = [ "fish_indent" ];
        javascript = {
          __unkeyed-1 = "prettierd";
          __unkeyed-2 = "prettier";
          timeout_ms = 2000;
          stop_after_first = true;
        };
        json = [ "jq" ];
        lua = [ "stylua" ];
        markdown = [ "deno_fmt" ];
        nix = [ "nixfmt" ];
        python = [
          "isort"
          "ruff"
        ];
        rust = [ "rustfmt" ];
        sh = [
          "shellcheck"
          "shellharden"
          "shfmt"
        ];
        sql = [ "sqlfluff" ];
        terraform = [ "terraform_fmt" ];
        toml = [ "taplo" ];
        typescript = {
          __unkeyed-1 = "prettierd";
          __unkeyed-2 = "prettier";
          timeout_ms = 2000;
          stop_after_first = true;
        };
        xml = [
          "xmlformat"
          "xmllint"
        ];
        yaml = [ "yamlfmt" ];
      };

      formatters = {
        taplo = {
          command = lib.getExe pkgs.taplo;
        };
        black = {
          command = lib.getExe pkgs.black;
        };
        bicep = {
          command = lib.getExe pkgs.bicep;
        };
        cmake-format = {
          command = lib.getExe pkgs.cmake-format;
        };
        deno_fmt = {
          command = lib.getExe pkgs.deno;
        };
        google-java-format = {
          command = lib.getExe pkgs.google-java-format;
        };
        jq = {
          command = lib.getExe pkgs.jq;
        };
        nixfmt = {
          command = lib.getExe pkgs.nixfmt-rfc-style;
        };
        prettierd = {
          command = lib.getExe pkgs.prettierd;
        };
        ruff = {
          command = lib.getExe pkgs.ruff;
        };
        rustfmt = {
          command = lib.getExe pkgs.rustfmt;
        };
        shellcheck = {
          command = lib.getExe pkgs.shellcheck;
        };
        shfmt = {
          command = lib.getExe pkgs.shfmt;
        };
        shellharden = {
          command = lib.getExe pkgs.shellharden;
        };
        sqlfluff = {
          command = lib.getExe pkgs.sqlfluff;
        };
        stylelint = {
          command = lib.getExe pkgs.stylelint;
        };
        stylua = {
          command = lib.getExe pkgs.stylua;
        };
        terraform_fmt = {
          command = lib.getExe pkgs.terraform;
        };
        yamlfmt = {
          command = lib.getExe pkgs.yamlfmt;
        };
      };
    };
  };
  none-ls = {
    enable = true;
    onAttach = {
      __raw = ''
        function(client, bufnr)
          if client.server_capabilities.inlayHintProvider then
              vim.lsp.inlay_hint(bufnr, true)
          end
        end
      '';
    };
    sources = {
      code_actions = {
        statix.enable = true;
        gomodifytags.enable = true;
        impl.enable = true;
      };
      completion = { };
      diagnostics = {
        statix.enable = true;
      };
      formatting = {
        sqlfluff.enable = true;
        goimports.enable = true;
        shellharden.enable = true;
        shfmt.enable = true;
        prettier = {
          enable = true;
          disableTsServerFormatter = true;
        };
      };
    };
  };
}

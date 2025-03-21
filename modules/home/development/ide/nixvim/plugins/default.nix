{
  lib,
  namespace,
  config,
  pkgs,
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
        # Editor
        sleuth = {
          enable = true;
          settings = { };
        };
        render-markdown = {
          enable = true;
          settings = { };
        };
        undotree = {
          enable = true;
          settings = {
            AutoOpenDiff = true;
            FocusOnToggle = true;
            CursorLine = true;
            DiffAutoOpen = true;
            DiffCommand = "diff";
            DiffpanelHeight = 10;
            HelpLine = true;
            HighlightChangedText = true;
            HighlightChangedWithSign = true;
            HighlightSyntaxAdd = "DiffAdd";
            HighlightSyntaxChange = "DiffChange";
            HighlightSyntaxDel = "DiffDelete";
            RelativeTimestamp = true;
            SetFocusWhenToggle = true;
            ShortIndicators = false;
            TreeNodeShape = "*";
            TreeReturnShape = "\\";
            TreeSplitShape = "/";
            TreeVertShape = "|";
          };
        };
        treesitter = {
          enable = true;
          settings = {
            highlight = {
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
        nvim-tree = {
          enable = true;
          syncRootWithCwd = true;
          respectBufCwd = true;
          updateFocusedFile = {
            enable = true;
            updateRoot = false;
          };
          renderer.icons.gitPlacement = "after";
          diagnostics.enable = true;
        };
        lazygit = {
          enable = true;
        };
        git-worktree = {
          enable = true;
          enableTelescope = true;
        };
        gitsigns = {
          enable = true;
          settings = {
            current_line_blame = true;
            current_line_blame_formatter = "   <author>, <committer_time:%R> • <summary>";
            trouble = true;
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
            lua_ls.enable = true;
            jsonls.enable = true;
            terraformls.enable = true;
            ts_ls.enable = true;
            tailwindcss.enable = true;
            cssls.enable = true;
            eslint = {
              enable = true;
              filetypes = [
                "html"
                "javascript"
                "javascriptreact"
                "javascript.jsx"
                "typescript"
                "typescriptreact"
                "typescript.tsx"
                "vue"
                "svelte"
                "astro"
              ];
            };
            # sqls.enable = true;
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
                      "https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json" =
                        "*docker-compose*.{yml,yaml}";
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
              { name = "cmp-ai"; }
              { name = "nvim_lsp"; }
              {
                name = "luasnip";
                keywordLength = 3;
              }
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
        neotest = {
          enable = true;
          adapters.go = {
            enable = true;
            settings = {
              args = {
                __raw = ''
                  {
                    "-v",
                    "-race",
                    "-coverprofile=" .. vim.fn.getcwd() .. "/coverage.out",
                  }
                '';
              };
            };
          };
          settings = { };
        };
        snacks = {
          enable = false;
          settings = { };
        };
        telescope = {
          enable = true;
          settings = {
          };
          extensions = {
            fzf-native = {
              enable = true;
            };
            ui-select = {
              enable = true;
            };
            file-browser = {
              enable = true;
              settings = {
              };
            };
            frecency = {
              enable = true;
            };
            manix = {
              enable = true;
            };
          };
          settings = { };
        };
        spectre = {
          enable = true;
          replacePackage = pkgs.gnused;
          settings = {
            is_block_ui_break = true;
          };
        };
        coverage = {
          enable = true;
        };
        fidget = {
          enable = true;
        };
        transparent = {
          enable = true;
          settings = { };
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
        notify = {
          enable = true;
        };
        noice = {
          enable = true;
          settings = {
            cmdline = {
              format = {
                cmdline = {
                  pattern = "^:";
                  icon = "";
                  lang = "vim";
                  opts = {
                    border = {
                      text = {
                        top = "Cmd";
                      };
                    };
                  };
                };
                search_down = {
                  kind = "search";
                  pattern = "^/";
                  icon = " ";
                  lang = "regex";
                };
                search_up = {
                  kind = "search";
                  pattern = "^%?";
                  icon = " ";
                  lang = "regex";
                };
                filter = {
                  pattern = "^:%s*!";
                  icon = "";
                  lang = "bash";
                  opts = {
                    border = {
                      text = {
                        top = "Bash";
                      };
                    };
                  };
                };
                lua = {
                  pattern = "^:%s*lua%s+";
                  icon = "";
                  lang = "lua";
                };
                help = {
                  pattern = "^:%s*he?l?p?%s+";
                  icon = "󰋖";
                };
                input = { };
              };
            };

            messages = {
              view = "mini";
              view_error = "mini";
              view_warn = "mini";
            };

            lsp = {
              override = {
                "vim.lsp.util.convert_input_to_markdown_lines" = true;
                "vim.lsp.util.stylize_markdown" = true;
                "cmp.entry.get_documentation" = true;
              };

              progress.enabled = true;
            };

            popupmenu.backend = "nui";
            presets = {
              bottom_search = false;
              command_palette = true;
              long_message_to_split = true;
              inc_rename = true;
              lsp_doc_border = true;
            };

            routes = [
              {
                filter = {
                  event = "msg_show";
                  kind = "search_count";
                };
                opts = {
                  skip = true;
                };
              }
              {
                # skip progress messages from noisy servers
                filter = {
                  event = "lsp";
                  kind = "progress";
                  cond.__raw = ''
                    function(message)
                      local client = vim.tbl_get(message.opts, 'progress', 'client')
                      local servers = { 'jdtls' }

                      for index, value in ipairs(servers) do
                          if value == client then
                              return true
                          end
                      end
                    end
                  '';
                };
                opts = {
                  skip = true;
                };
              }
            ];

            views = {
              cmdline_popup = {
                border = {
                  style = "single";
                };
              };

              confirm = {
                border = {
                  style = "single";
                  text = {
                    top = "";
                  };
                };
              };
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
        which-key = {
          enable = true;
          settings = {
            preset = "helix";
            delay = 0;
            spec = [
              {
                __unkeyed = "<leader>f";
                group = "Find";
              }
              {
                __unkeyed = "<leader>l";
                group = "LSP";
              }
              {
                __unkeyed = "<leader>t";
                group = "Testing";
              }
              {
                __unkeyed = "<leader>e";
                group = "File Explorer";
              }
              {
                __unkeyed = "<leader>g";
                group = "Git";
              }
              {
                __unkeyed = "<leader>a";
                group = "AI";
              }
              {
                __unkeyed = "<leader>w";
                group = "Moving Around";
              }
            ];
          };
        };
        lspkind = {
          enable = true;
          cmp = {
            enable = true;
          };
          extraOptions = {
            maxwidth = 50;
            ellipsis_char = "...";
          };
        };

      };
    };
  };
}

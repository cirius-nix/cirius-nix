{
  fidget = {
    enable = true;
  };
  transparent = {
    enable = true;
    settings = { };
  };
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
      # Doesn't support the standard cmdline completions
      # popupmenu.backend = "cmp";

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
}

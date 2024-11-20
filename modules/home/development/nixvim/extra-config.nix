let
  autoCommands = ''
    local slow_format_filetypes = {}

    vim.api.nvim_create_user_command("FormatDisable", function(args)
       if args.bang then
        -- FormatDisable! will disable formatting just for this buffer
        vim.b.disable_autoformat = true
      else
        vim.g.disable_autoformat = true
      end
    end, {
      desc = "Disable autoformat-on-save",
      bang = true,
    })
    vim.api.nvim_create_user_command("FormatEnable", function()
      vim.b.disable_autoformat = false
      vim.g.disable_autoformat = false
    end, {
      desc = "Re-enable autoformat-on-save",
    })
    vim.api.nvim_create_user_command("FormatToggle", function(args)
      if args.bang then
        -- Toggle formatting for current buffer
        vim.b.disable_autoformat = not vim.b.disable_autoformat
      else
        -- Toggle formatting globally
        vim.g.disable_autoformat = not vim.g.disable_autoformat
      end
    end, {
      desc = "Toggle autoformat-on-save",
      bang = true,
    })
  '';
  extraFuncs = ''
    _G.FUNCS = {
      focus_or_close = function()
        local win = vim.api.nvim_get_current_win()
        if vim.bo.filetype == "NvimTree" then
          vim.api.nvim_win_close(win, true)
        else
          vim.cmd("NvimTreeRefresh")
          vim.cmd("NvimTreeFocus")
        end
      end,
      cmp_jump_next = function()
      end,
      cmp_jump_prev = function()
      end,
      get_selected_text_in_visual_mode = function()
        vim.cmd('noau normal! "vy"')
        local text = vim.fn.getreg("v")
        vim.fn.setreg("v", {})

        text = string.gsub(text, "\n", "")
        if #text > 0 then
          return text
        else
          return ""
        end
      end,
      search_selected_text_in_visual_mode = function()
        local text = _G.FUNCS.get_selected_text_in_visual_mode()
        require("telescope.builtin").live_grep({ default_text = text })
      end,
      ts_organize_imports = function()
        local params = {
          command = "_typescript.organizeImports",
          arguments = {vim.api.nvim_buf_get_name(0)},
          title = ""
        }
        vim.lsp.buf.execute_command(params)
      end
    };
  '';
in
{
  extraConfigLua = ''
    require("codecompanion").setup({
      adapters = {
        authropic = function()
          local authropic_api_key = os.getenv("AUTHROPIC_API_KEY")
          print(authropic_api_key)
          return require("codecompanion.adapters").extend("authropic", {
            env = {
              api_key = authropic_api_key,
            }
          })
        end
      },
      strategies = {
        chat = {
          adapter = "anthropic",
        },
        inline = {
          adapter = "anthropic",
        },
        agent = {
          adapter = "anthropic",
        },
      },
    });


    require("img-clip").setup({
      default = {
        embed_image_as_base64 = false,
        prompt_for_file_name = false,
        drag_and_drop = {
          insert_mode = true,
        },
        use_absolute_path = true,
      },
    })

    require("render-markdown").setup({
      file_types = { "markdown", "Avante" },
    })

    require('lspconfig.ui.windows').default_options = {
      border = "rounded"
    }

    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
      vim.lsp.handlers.hover, {
        border = "rounded"
      }
    )

    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
      vim.lsp.handlers.signature_help, {
        border = "rounded"
      }
    )

    vim.diagnostic.config({
      float = { border = "rounded" },
      virtual_text = {
        prefix = "",
      },
      signs = true,
      underline = true,
      update_in_insert = true,
    })
  '';
  extraConfigLuaPre = extraFuncs + autoCommands;
  extraConfigLuaPost = ''
    require("telescope").load_extension("lazygit")
  '';
}

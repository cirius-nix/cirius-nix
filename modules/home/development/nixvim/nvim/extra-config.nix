let
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
  extraConfigLuaPre = extraFuncs;
  extraConfigLuaPost = ''
    require("telescope").load_extension("lazygit")
  '';
}

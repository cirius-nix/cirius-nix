{
  config,
  namespace,
  lib,
  ...
}:
let
  cfg = config.${namespace}.development.ide.nixvim;

  langCfg = cfg.plugins.languages;
  goCfg = langCfg.go;
  inherit (lib) mkIf;

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

    -- Toggle auto format buffer on save.
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

    -- Turn off paste mode when leaving insert
    vim.api.nvim_create_autocmd("InsertLeave", {
      pattern = "*",
      command = "set nopaste",
    })

    -- Fix conceallevel for json files
    vim.api.nvim_create_autocmd("FileType", {
      pattern = {"json", "jsonc"},
      callback = function()
        vim.wo.spell = false
        vim.wo.conceallevel = 0
      end,
    })

    -- EslintFixAll
  '';
in
{
  config = mkIf cfg.enable {
    programs.nixvim = {
      extraConfigLuaPre =
        extraFuncs
        + autoCommands
        + (
          if (goCfg.enable && goCfg.use3rdPlugins.rayxgo.enable) then
            goCfg.use3rdPlugins.rayxgo.configPre
          else
            ""
        );

      extraConfigLua =
        ''
          vim.filetype.add({
            extension = {
              gotmpl = 'gotmpl',
            },
            pattern = {
              [".*/templates/.*%.tpl"] = "helm",
              [".*/templates/.*%.ya?ml"] = "helm",
              ["helmfile.*%.ya?ml"] = "helm",
            },
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
        ''
        + (
          if (goCfg.enable && goCfg.use3rdPlugins.rayxgo.enable) then
            goCfg.use3rdPlugins.rayxgo.config
          else
            ""
        );

      extraConfigLuaPost =
        ''
          require("telescope").load_extension("lazygit")

          local dap, dapui =require("dap"),require("dapui")
          dap.listeners.after.event_initialized["dapui_config"]=function()
            dapui.open()
          end
          dap.listeners.before.event_terminated["dapui_config"]=function()
            dapui.close()
          end
          dap.listeners.before.event_exited["dapui_config"]=function()
            dapui.close()
          end
        ''
        + (
          if (goCfg.enable && goCfg.use3rdPlugins.rayxgo.enable) then
            goCfg.use3rdPlugins.rayxgo.configPost
          else
            ""
        );
    };
  };
}

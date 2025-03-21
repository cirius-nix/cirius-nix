{
  lib,
  namespace,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.${namespace}.development.ide.nixvim.plugins.formatter;
in
{
  options.${namespace}.development.ide.nixvim.plugins.formatter = {
    enable = mkEnableOption "Formatter support";
  };

  config = mkIf cfg.enable {
    programs.nixvim = {
      plugins = {
        conform-nvim = {
          enable = true;
          settings = {
            format_on_save = # Lua
              ''
                function(bufnr)
                  if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
                    return
                  end

                  if _M.slow_format_filetypes[vim.bo[bufnr].filetype] then
                    return
                  end

                  local function on_format(err)
                    if err and err:match("timeout$") then
                      _M.slow_format_filetypes[vim.bo[bufnr].filetype] = true
                    end
                  end

                  return { timeout_ms = 2000, lsp_fallback = true }, on_format
                 end
              '';

            format_after_save = # Lua
              ''
                function(bufnr)
                  if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
                    return
                  end

                  if not _M.slow_format_filetypes[vim.bo[bufnr].filetype] then
                    return
                  end

                  return { lsp_fallback = true }
                end
              '';
          };
        };
      };
      extraConfigLuaPost = ''
        vim.api.nvim_create_user_command("FormatDisable", function(args)
          if args.bang then
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
      '';
    };
  };
}

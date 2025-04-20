{
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.development.ide.nixvim;
  inherit (lib) mkIf;

  wincmd-keymaps = [
    {
      action = "<cmd>wincmd h<cr>";
      key = "<leader>wh";
      mode = "n";
      options = {
        silent = true;
        desc = " Move To Left";
      };
    }
    {
      action = "<cmd>wincmd j<cr>";
      key = "<leader>wj";
      mode = "n";
      options = {
        silent = true;
        desc = " Move To Down";
      };
    }
    {
      action = "<cmd>wincmd k<cr>";
      key = "<leader>wk";
      mode = "n";
      options = {
        silent = true;
        desc = " Move to Up";
      };
    }
    {
      action = "<cmd>wincmd l<cr>";
      key = "<leader>wl";
      mode = "n";
      options = {
        silent = true;
        desc = " Move To Right";
      };
    }
  ];
in
{
  config = mkIf cfg.enable {
    programs.nixvim = {
      extraConfigLuaPre = ''
        vim.api.nvim_create_autocmd("FileType", {
          pattern = {"neotest-output-panel"},
          callback = function()
            vim.schedule(function()
              -- set keymap q in normal mode to close the panel
              vim.api.nvim_buf_set_keymap(0, "n", "q", "<cmd>close<cr>", {noremap = true, silent = true})
            end)
          end
        })
      '';
      keymaps = [
        {
          action = "<cmd>xa<cr>";
          key = "<leader>q";
          mode = "n";
          options = {
            silent = true;
            nowait = true;
            desc = "󰸧 Save and close";
          };
        }
        {
          action = "<cmd>nohlsearch<cr>";
          key = "<esc>";
          mode = "n";
          options = {
            silent = true;
            nowait = true;
          };
        }
        {
          mode = "i";
          key = "jk";
          action = "<esc>";
          options = {
            silent = true;
            nowait = true;
            desc = "Escape";
          };
        }
        {
          mode = "i";
          key = "jj";
          action = "<esc>";
          options = {
            silent = true;
            nowait = true;
            desc = "Escape";
          };
        }

      ] ++ wincmd-keymaps;
    };
  };
}

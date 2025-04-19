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
        desc = "Move To Left";
      };
    }
    {
      action = "<cmd>wincmd j<cr>";
      key = "<leader>wj";
      mode = "n";
      options = {
        silent = true;
        desc = "Move To Down";
      };
    }
    {
      action = "<cmd>wincmd k<cr>";
      key = "<leader>wk";
      mode = "n";
      options = {
        silent = true;
        desc = "Move to Up";
      };
    }
    {
      action = "<cmd>wincmd l<cr>";
      key = "<leader>wl";
      mode = "n";
      options = {
        silent = true;
        desc = "Move To Right";
      };
    }
  ];
in
{
  config = mkIf cfg.enable {
    programs.nixvim = {
      keymaps = [
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
          mode = "n";
          key = "<leader>fu";
          action = "<cmd>UndotreeToggle<CR>";
          options = {
            silent = true;
            desc = "Open Undo Tree";
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

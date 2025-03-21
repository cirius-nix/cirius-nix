{
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.development.ide.nixvim;
  inherit (lib) mkIf;

  git_keymaps = [
    {
      action = "<cmd>Gitsigns diffthis<cr>";
      key = "<leader>gd";
      mode = "n";
      options = {
        silent = true;
        nowait = true;
      };
    }
    {
      action = "<cmd>Gitsigns prev_hunk<cr>";
      key = "[g";
      mode = "n";
      options = {
        silent = true;
        nowait = true;
      };
    }
    {
      action = "<cmd>Gitsigns next_hunk<cr>";
      key = "]g";
      mode = "n";
      options = {
        silent = true;
        nowait = true;
      };
    }
    {
      action = "<cmd>Gitsigns stage_hunk<cr>";
      key = "ga";
      mode = "n";
      options = {
        silent = true;
        nowait = true;
        desc = "Stage Hunk";
      };
    }
    {
      action = "<cmd>Gitsigns undo_stage_hunk<cr>";
      key = "gA";
      mode = "n";
      options = {
        silent = true;
        nowait = true;
        desc = "Undo Stage Hunk";
      };
    }
    {
      action = "<cmd>Gitsigns stage_hunk<cr>";
      key = "<leader>ga";
      mode = "n";
      options = {
        silent = true;
        nowait = true;
        desc = "Stage Hunk";
      };
    }
    {
      action = "<cmd>Gitsigns undo_stage_hunk<cr>";
      key = "<leader>gA";
      mode = "n";
      options = {
        silent = true;
        nowait = true;
        desc = "Undo Stage Hunk";
      };
    }
    {
      action = "<cmd>Gitsigns setqflist<cr>";
      key = "<leader>gx";
      mode = "n";
      options = {
        silent = true;
        nowait = true;
        desc = "Open Quick Fix";
      };
    }
    {
      action = "<cmd>LazyGit<cr>";
      key = "<leader>gl";
      mode = "n";
      options = {
        silent = true;
        nowait = true;
        desc = "LazyGit (Root Dir)";
      };
    }
  ];
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
      keymaps =
        [
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

        ]
        ++ wincmd-keymaps
        ++ git_keymaps;
    };
  };
}

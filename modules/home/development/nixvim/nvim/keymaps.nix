let
  testing_keymaps = [
    {
      mode = "n";
      key = "<leader>tr";
      action = "<cmd>Neotest run file<cr>";
      options = {
        silent = true;
        nowait = true;
      };
    }
    {
      mode = "n";
      key = "<leader>tl";
      action = "<cmd>Neotest run last<cr>";
      options = {
        silent = true;
        nowait = true;
      };
    }
    {
      mode = "n";
      key = "<leader>tc";
      action = "<cmd>Coverage<cr>";
      options = {
        silent = true;
        nowait = true;
      };
    }
    {
      mode = "n";
      key = "<leader>tC";
      action = "<cmd>CoverageSummary<cr>";
      options = {
        silent = true;
        nowait = true;
      };
    }
    {
      mode = "n";
      key = "<leader>to";
      action = "<cmd>Neotest summary toggle<cr>";
      options = {
        silent = true;
        nowait = true;
      };
    }
    {
      mode = "n";
      key = "<leader>tp";
      action = "<cmd>Neotest output-panel toggle<cr>";
      options = {
        silent = true;
        nowait = true;
      };
    }
  ];
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
      };
    }
    {
      action = "<cmd>Gitsigns undo_stage_hunk<cr>";
      key = "gA";
      mode = "n";
      options = {
        silent = true;
        nowait = true;
      };
    }
    {
      action = "<cmd>Gitsigns stage_hunk<cr>";
      key = "<leader>ga";
      mode = "n";
      options = {
        silent = true;
        nowait = true;
      };
    }
    {
      action = "<cmd>Gitsigns undo_stage_hunk<cr>";
      key = "<leader>gA";
      mode = "n";
      options = {
        silent = true;
        nowait = true;
      };
    }
    {
      action = "<cmd>Gitsigns setqflist<cr>";
      key = "<leader>gx";
      mode = "n";
      options = {
        silent = true;
        nowait = true;
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
  nvimtree-keymaps = [
    {
      action = "<cmd>lua _G.FUNCS.focus_or_close()<cr>";
      key = "<leader>e";
      mode = "n";
      options = {
        silent = true;
        nowait = true;
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
      };
    }
    {
      action = "<cmd>wincmd j<cr>";
      key = "<leader>wj";
      mode = "n";
      options = {
        silent = true;
      };
    }
    {
      action = "<cmd>wincmd k<cr>";
      key = "<leader>wk";
      mode = "n";
      options = {
        silent = true;
      };
    }
    {
      action = "<cmd>wincmd l<cr>";
      key = "<leader>wl";
      mode = "n";
      options = {
        silent = true;
      };
    }
  ];
  telescope-keymaps = [
    {
      action = "<cmd>Telescope find_files<cr>";
      key = "<leader>ff";
      mode = "n";
      options = {
        silent = true;
      };
    }
    {
      action = "<cmd>Telescope live_grep<cr>";
      key = "<leader>fs";
      mode = "n";
      options = {
        silent = true;
      };
    }
    {
      action = "<cmd>lua _G.FUNCS.search_selected_text_in_visual_mode()<cr>";
      key = "<leader>fs";
      mode = "v";
      options = {
        silent = true;
      };
    }
    {
      action = "<cmd>'<,'>Wtf<cr>";
      key = "<leader>fw";
      mode = "v";
      options = {
        silent = true;
      };
    }
    {
      action = "<cmd>Telescope buffers<cr>";
      key = "<leader>fb";
      mode = "n";
      options = {
        silent = true;
      };
    }
    {
      action = "<cmd>Telescope resume<cr>";
      key = "<leader>fr";
      mode = "n";
      options = {
        silent = true;
      };
    }
    {
      action = "<cmd>TodoTrouble<cr>";
      key = "<leader>ft";
      mode = "n";
      options = {
        silent = true;
      };
    }
  ];
in
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
      desc = "Undotree";
    };
  }
  {
    mode = "i";
    key = "jk";
    action = "<esc>";
    options = {
      silent = true;
      nowait = true;
    };
  }
  {
    mode = "i";
    key = "jj";
    action = "<esc>";
    options = {
      silent = true;
      nowait = true;
    };
  }
  {
    mode = "n";
    key = "<leader>m";
    action = "<cmd>ZenMode<cr>";
    options = {
      silent = true;
      nowait = true;
    };
  }
] ++ nvimtree-keymaps ++ wincmd-keymaps ++ telescope-keymaps ++ git_keymaps ++ testing_keymaps

let
  search_keymaps = [
    {
      mode = [ "n" ];
      key = "<leader>s";
      action = "<cmd>lua require('spectre').toggle()<cr>";
      options = {
        silent = true;
        desc = "Search To Replace";
      };
    }
    {
      mode = [ "v" ];
      key = "<leader>s";
      action = "<cmd>lua require('spectre').open_visual()<cr>";
      options = {
        silent = true;
        desc = "Search To Replace";
      };
    }
  ];
  companion_keymaps = [
    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>a";
      action = "CodeCompanion";
      options = {
        silent = true;
        desc = "AI";
      };
    }
    {
      key = "<leader>ac";
      action = ":CodeCompanionToggle<CR>";
      mode = "n";
      options = {
        silent = true;
        desc = "Toggle Prompt";
      };
    }
    {
      key = "<leader>af";
      action = ":CodeCompanionActions<CR>";
      mode = "n";
      options = {
        silent = true;
        desc = "Open Actions";
      };
    }
  ];
  testing_keymaps = [
    {
      mode = "n";
      key = "<leader>tr";
      action = "<cmd>Neotest run file<cr>";
      options = {
        silent = true;
        nowait = true;
        desc = "Test File";
      };
    }
    {
      mode = "n";
      key = "<leader>tl";
      action = "<cmd>Neotest run last<cr>";
      options = {
        silent = true;
        nowait = true;
        desc = "Test Last";
      };
    }
    {
      mode = "n";
      key = "<leader>tc";
      action = "<cmd>Coverage<cr>";
      options = {
        silent = true;
        nowait = true;
        desc = "Show Coverage Highlight";
      };
    }
    {
      mode = "n";
      key = "<leader>tC";
      action = "<cmd>CoverageSummary<cr>";
      options = {
        silent = true;
        nowait = true;
        desc = "Show Coverage Summary";
      };
    }
    {
      mode = "n";
      key = "<leader>to";
      action = "<cmd>Neotest summary toggle<cr>";
      options = {
        silent = true;
        nowait = true;
        desc = "Toggle Test Summary";
      };
    }
    {
      mode = "n";
      key = "<leader>tp";
      action = "<cmd>Neotest output-panel toggle<cr>";
      options = {
        silent = true;
        nowait = true;
        desc = "Show Test Panel";
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
  nvimtree-keymaps = [
    {
      action = "<cmd>lua _G.FUNCS.focus_or_close()<cr>";
      key = "<leader>e";
      mode = "n";
      options = {
        silent = true;
        nowait = true;
        desc = "File Explorer";
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
  telescope-keymaps = [
    {
      action = "<cmd>Telescope find_files<cr>";
      key = "<leader>ff";
      mode = "n";
      options = {
        silent = true;
        desc = "Find Files";
      };
    }
    {
      action = "<cmd>Telescope live_grep<cr>";
      key = "<leader>fs";
      mode = "n";
      options = {
        silent = true;
        desc = "Grep String";
      };
    }
    {
      action = "<cmd>lua _G.FUNCS.search_selected_text_in_visual_mode()<cr>";
      key = "<leader>fs";
      mode = "v";
      options = {
        silent = true;
        desc = "Search Selected Text";
      };
    }
    {
      action = "<cmd>'<,'>Wtf<cr>";
      key = "<leader>fw";
      mode = "v";
      options = {
        silent = true;
        desc = "Wtf";
      };
    }
    {
      action = "<cmd>Telescope buffers<cr>";
      key = "<leader>fb";
      mode = "n";
      options = {
        silent = true;
        desc = "Show Opened Buffers";
      };
    }
    {
      action = "<cmd>Telescope resume<cr>";
      key = "<leader>fr";
      mode = "n";
      options = {
        silent = true;
        desc = "Search History";
      };
    }
    {
      action = "<cmd>TodoTrouble<cr>";
      key = "<leader>ft";
      mode = "n";
      options = {
        silent = true;
        desc = "Todolist";
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
  {
    mode = "n";
    key = "<leader>m";
    action = "<cmd>ZenMode<cr>";
    options = {
      silent = true;
      nowait = true;
      desc = "Focus Mode";
    };
  }
]
++ nvimtree-keymaps
++ wincmd-keymaps
++ telescope-keymaps
++ git_keymaps
++ testing_keymaps
++ companion_keymaps
++ search_keymaps

let
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
] ++ nvimtree-keymaps ++ wincmd-keymaps ++ telescope-keymaps

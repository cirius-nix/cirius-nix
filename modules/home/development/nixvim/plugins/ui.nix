{
  rainbow-delimiters.enable = true;
  todo-comments.enable = true;
  zen-mode = {
    enable = true;
    settings = {
      on_close = '''';
      on_open = '''';
      plugins = {
        options = {
          enabled = true;
          ruler = false;
          showcmd = false;
        };
        tmux = {
          enabled = false;
        };
        twilight = {
          enabled = false;
        };
      };
      window = {
        backdrop = 0.95;
        height = 1;
        options = {
          signcolumn = "no";
        };
        width = 0.8;
      };
    };
  };
  wilder = {
    enable = true;
  };
  trouble = {
    enable = true;
    settings = {
      auto_close = true;
    };
  };
  dressing.enable = true;
  lualine.enable = true;
  bufferline.enable = true;
  which-key.enable = true;
  lspkind = {
    enable = true;
    cmp = {
      enable = true;
    };
    extraOptions = {
      maxwidth = 50;
      ellipsis_char = "...";
    };
  };
}

{
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.development.ide.nixvim;
  inherit (lib) mkIf;
in
{
  config = mkIf cfg.enable {
    programs.nixvim = {
      opts = {
        timeout = true;
        autowrite = true;
        clipboard = "unnamedplus";
        background = "dark";
        # completeopt = "menu,menuone,noselect";
        completeopt = "menu,noinsert,popup,fuzzy";
        conceallevel = 3;
        confirm = true;
        cursorline = true;
        expandtab = true;
        formatoptions = "jcroqlnt";
        grepformat = "%f:%l:%c:%m";
        grepprg = "rg --vimgrep";
        ignorecase = true;
        inccommand = "nosplit";
        laststatus = 3;
        list = true;
        mouse = "a";
        number = true;
        pumblend = 10;
        pumheight = 10;
        relativenumber = false;
        scrolloff = 4;
        shiftround = true;
        shiftwidth = 2;
        showmode = false;
        sidescrolloff = 8;
        signcolumn = "yes";
        smartcase = true;
        smartindent = true;
        splitbelow = true;
        splitkeep = "screen";
        splitright = true;
        tabstop = 2;
        termguicolors = true;
        timeoutlen = 500;
        undofile = true;
        undolevels = 10000;
        updatetime = 200;
        virtualedit = "block";
        wildmode = "longest:full,full";
        winminwidth = 5;
        wrap = true;
        # Users may find that the borders on their hover windows have vanished
        # after updating. This is because Neovim no longer uses global
        # callbacks for LSP responses (a necessary breaking change to correctly
        # support multiple LSP clients in a buffer), so overriding
        # vim.lsp.handlers['textDocument/hover'] to add borders to the hover
        # window will no longer work. Fortunately, there is also a new option
        # in this release called winborder which sets the default border for
        # all floating windows. For example, use vim.o.winborder = 'rounded' to
        # use rounded borders on all floating windows.
        # INFO: currently winborder breaks all ui that implemented custom win border.
        winborder = "rounded"; # https://gpanders.com/blog/whats-new-in-neovim-0-11/#improved-hover-documentation
      };
    };
  };
}

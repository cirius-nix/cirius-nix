{
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.development.ide.nixvim;
  inherit (lib)
    mkEnableOption
    mkIf
    types
    ;

  inherit (lib.${namespace}) mkOpt mkStrOption;

  user = config.${namespace}.user;
in
{
  imports = lib.snowfall.fs.get-non-default-nix-files ./.;

  options.${namespace}.development.ide.nixvim = {
    enable = mkEnableOption "Enable NixVim or not";
    colorscheme = mkOpt types.str "catppuccin-frappe" "The colorscheme to use";
    baseSecretPath = mkStrOption "${user.username}/default.yaml" "Base secret path";
  };

  config = mkIf cfg.enable {
    ${namespace}.development.cli-utils.fish = {
      interactiveEnvs = {
        "EDITOR" = "nvim";
      };
    };
    programs.nixvim = {
      enable = true;
      withNodeJs = true;
      withPerl = true;
      withRuby = true;
      extraConfigLuaPre = ''
        vim.api.nvim_create_autocmd("FileType", {
          pattern = {"neotest-output-panel"},
          callback = function()
            vim.schedule(function()
              vim.api.nvim_buf_set_keymap(0, "n", "q", "<cmd>close<cr>", {noremap = true, silent = true})
            end)
          end
        })

        _G.FUNCS = {
          load_secret = function(name, path)
            local f = io.open(path, "r")
            if not f then
              return nil
            end

            local data = f:read("*a")
            f:close()

            local token = data:gsub("%s+$", "")
            vim.g[name] = token
            vim.fn.setenv(name, token)

            return token
          end
        };
        _M.slow_format_filetypes = {};
        _G.FUNCS.load_secret("GEMINI_API_KEY", "${config.sops.secrets."gemini_auth_token".path}")
        _G.FUNCS.load_secret("OPENAI_API_KEY", "${config.sops.secrets."openai_auth_token".path}")
        _G.FUNCS.load_secret("GROQ_API_KEY", "${config.sops.secrets."groq_auth_token".path}")
        _G.FUNCS.load_secret("DEEPSEEK_API_KEY", "${config.sops.secrets."deepseek_auth_token".path}")
        _G.FUNCS.load_secret("DASHSCOPE_API_KEY", "${config.sops.secrets."qwen_auth_token".path}")
      '';
      diagnostic.settings = {
        float = {
          border = "rounded";
        };
        virtual_lines = {
          current_line = true;
        };
        virtual_text = true;
        signs = true;
        underline = true;
        update_in_insert = false;
      };
      autoGroups = {
        builtin_auto_completion = {
          clear = true;
        };
      };
      globals = {
        mapleader = " ";
        maplocalleader = "\\";
        loaded_netrw = 1;
        loaded_netrwPlugin = 1;
      };
      keymaps =
        let
          inherit
            (import ../keybindings.nix {
              inherit lib namespace;
            })
            common
            wincmd
            ;
        in
        lib.concatLists [
          common.nixvim
          wincmd.nixvim
        ];
      editorconfig.enable = true;
      clipboard.register = "unnamedplus";
      performance = {
        byteCompileLua = {
          enable = false;
          nvimRuntime = true;
          configs = true;
          plugins = true;
        };
      };
      opts = {
        timeout = true;
        autowrite = true;
        clipboard = "unnamedplus";
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
        winborder = "rounded";
      };
    };
  };
}

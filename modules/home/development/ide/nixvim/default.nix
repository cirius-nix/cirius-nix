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

  inherit (lib.${namespace}) mkOpt;
in
{
  imports = lib.snowfall.fs.get-non-default-nix-files ./.;

  options.${namespace}.development.ide.nixvim = {
    enable = mkEnableOption "Enable NixVim or not";
    colorscheme = mkOpt types.str "gruvbox" "The colorscheme to use";
  };

  config = mkIf cfg.enable {
    ${namespace}.development.cli-utils.fish = {
      interactiveEnvs = {
        "EDITOR" = "nvim";
      };

      interactiveFuncs = {
        "nv" = ''
          set -gx GEMINI_API_KEY (cat ${config.sops.secrets."gemini_auth_token".path})
          set -gx OPENAI_API_KEY (cat ${config.sops.secrets."openai_auth_token".path})
          nvim
        '';
      };
    };
    programs.nixvim = {
      enable = true;
      colorschemes = {
        catppuccin = {
          enable = true;
          settings = {
            background.light = "latte";
            background.dark = "macchiato";
          };
        };
      };
      withNodeJs = true;
      withPerl = true;
      withRuby = true;
      extraConfigLuaPre = ''
        -- Global functions
        _G.FUNCS = {};
        _M.slow_format_filetypes = {};
      '';
      diagnostics = {
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
    };
  };
}

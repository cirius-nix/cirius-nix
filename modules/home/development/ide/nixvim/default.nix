{
  config,
  lib,
  namespace,
  ...
}:
# This is a NixOS module for configuring NixVim.
let
  # Access the configuration for this module using the namespace.
  cfg = config.${namespace}.development.ide.nixvim;
  # Import necessary functions from the Nix libraries.
  inherit (lib)
    mkEnableOption
    mkIf
    types
    ;

  # Import necessary functions from the module libraries.
  inherit (lib.${namespace}) mkOpt;
in
{
  # Import non-default Nix files from the current directory.
  imports = lib.snowfall.fs.get-non-default-nix-files ./.;

  # Define the options for this module.
  options.${namespace}.development.ide.nixvim = {
    # Enable NixVim or not.
    enable = mkEnableOption "Enable NixVim or not";
    # The colorscheme to use.
    colorscheme = mkOpt types.str "gruvbox" "The colorscheme to use";
  };

  # Configuration for this module.
  config = mkIf cfg.enable {
    # Configure fish shell.
    ${namespace}.development.cli-utils.fish = {
      # Set interactive environment variables.
      interactiveEnvs = {
        "EDITOR" = "nvim";
      };
      interactiveFuncs = {
        av = ''
          set -gx GEMINI_API_KEY (cat ${config.sops.secrets."gemini_auth_token".path})
          set -gx OPENAI_API_KEY (cat ${config.sops.secrets."openai_auth_token".path})
          set -gx GROQ_API_KEY (cat ${config.sops.secrets."groq_auth_token".path})
          set -gx DEEPSEEK_API_KEY (cat ${config.sops.secrets."deepseek_auth_token".path})
          set -gx DASHSCOPE_API_KEY (cat ${config.sops.secrets."qwen_auth_token".path})
          nvim $argv
        '';
      };
    };
    # Configure NixVim.
    programs.nixvim = {
      enable = true;
      # Set environment variables for NixVim.
      # Configure colorschemes for NixVim.
      colorschemes = {
        catppuccin = {
          enable = true;
          settings = {
            background.light = "latte";
            background.dark = "macchiato";
          };
        };
      };
      # Enable NodeJS support for NixVim.
      withNodeJs = true;
      # Enable Perl support for NixVim.
      withPerl = true;
      # Enable Ruby support for NixVim.
      withRuby = true;
      # Extra Lua configuration to be added before plugins are loaded.
      extraConfigLuaPre = ''
        -- Global functions
        _G.FUNCS = {};
        _M.slow_format_filetypes = {};
      '';
      # Configure diagnostics for NixVim.
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
      # Configure auto groups for NixVim.
      autoGroups = {
        builtin_auto_completion = {
          clear = true;
        };
      };
      # Enable editorconfig support for NixVim.
      editorconfig.enable = true;
      # Configure clipboard for NixVim.
      clipboard.register = "unnamedplus";
      # Configure performance settings for NixVim.
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

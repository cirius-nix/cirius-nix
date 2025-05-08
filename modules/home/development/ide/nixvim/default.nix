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
  inherit (lib.${namespace}) mkOpt mkStrOption;

  # User information
  user = config.${namespace}.user;

in
{
  # Import non-default Nix files from the current directory.
  imports = lib.snowfall.fs.get-non-default-nix-files ./.;

  # Define the options for this module.
  options.${namespace}.development.ide.nixvim = {
    # Enable NixVim or not.
    enable = mkEnableOption "Enable NixVim or not";
    # The colorscheme to use.
    colorscheme = mkOpt types.str "catppuccin-frappe" "The colorscheme to use";
    baseSecretPath = mkStrOption "${user.username}/default.yaml" "Base secret path";
  };

  # Configuration for this module.
  config = mkIf cfg.enable {
    # Configure fish shell.
    ${namespace}.development.cli-utils.fish = {
      # Set interactive environment variables.
      interactiveEnvs = {
        "EDITOR" = "nvim";
      };
    };
    # Configure NixVim.
    programs.nixvim = {
      enable = true;
      # Enable NodeJS support for NixVim.
      withNodeJs = true;
      # Enable Perl support for NixVim.
      withPerl = true;
      # Enable Ruby support for NixVim.
      withRuby = true;
      # Extra Lua configuration to be added before plugins are loaded.
      extraConfigLuaPre = ''
        -- Global functions
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
        -- TODO: integration with ...
        _G.FUNCS.load_secret("GEMINI_API_KEY", "${config.sops.secrets."gemini_auth_token".path}")
        _G.FUNCS.load_secret("OPENAI_API_KEY", "${config.sops.secrets."openai_auth_token".path}")
        _G.FUNCS.load_secret("GROQ_API_KEY", "${config.sops.secrets."groq_auth_token".path}")
        _G.FUNCS.load_secret("DEEPSEEK_API_KEY", "${config.sops.secrets."deepseek_auth_token".path}")
        _G.FUNCS.load_secret("DASHSCOPE_API_KEY", "${config.sops.secrets."qwen_auth_token".path}")
      '';
      # Configure diagnostics for NixVim.
      # diagnostics renamed to diagnostic.settings
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

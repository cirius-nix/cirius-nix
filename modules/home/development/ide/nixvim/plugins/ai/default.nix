{
  namespace,
  lib,
  config,
  pkgs,
  ...
}:
# This is a NixOS module for configuring AI plugins for NixVim.
let
  # Access the configuration for this module using the namespace.
  cfg = config.${namespace}.development.ide.nixvim.plugins.ai;
  # Import necessary functions from the Nix libraries.
  inherit (lib) mkEnableOption mkIf;
  # Import necessary functions from the module libraries.
  inherit (lib.${namespace}) mkEnumOption mkAttrsOption;

  # Check if AI is enabled at the OS level.
  osEnabledAI = config.${namespace}.development.ai.enable;

  # Define presets for Avante AI plugin.
  avanteProviders = {
    "gemini" = "gemini";
    "groq" = "groq";
    "deepseek" = "deepseek";
    "qwen" = "qianwen";
    "ollama" = "ollama";
  };
in
{
  # Define the options for this module.
  options.${namespace}.development.ide.nixvim.plugins.ai = {
    # Enable AI plugins for NixVim.
    enable = mkEnableOption "Enable AI plugins for NixVim";
    # Configuration options for the Avante AI plugin.
    avante = {
      # Select a provider for Avante.
      provider = mkEnumOption [ "gemini" "groq" "deepseek" "ollama" "qwen" ] "gemini" "provider";
      customConfig = mkAttrsOption lib.types.anything { } "Custom vendors";
    };
  };
  # Configuration for this module.
  config = mkIf (cfg.enable && osEnabledAI) {
    # Configure programs.
    programs = {
      # Configure NixVim.
      nixvim = {
        # Extra Lua configuration to be added before plugins are loaded.
        extraConfigLuaPre = ''
          vim.g.tabby_agent_start_command = {"${pkgs.tabby-agent}/bin/tabby-agent", "--stdio", "--lsp"}
          vim.g.tabby_inline_completion_trigger = "auto"
          vim.g.tabby_inline_completion_keybinding_accept = "<s-cr>"
        '';
        # Extra plugins to be added to NixVim.
        extraPlugins = [
          pkgs.vimPlugins.vim-tabby
        ];
        keymaps = [ ];
        # Configure plugins.
        plugins = {
          # Configure Avante AI plugin.
          avante = {
            enable = true;
            settings = lib.foldl' lib.recursiveUpdate { } [
              {
                provider = avanteProviders.${cfg.avante.provider};
                behavior = {
                  enable_cursor_planning_mode = true;
                  auto_suggestions = false;
                  auto_set_highlight_group = true;
                  auto_set_keymaps = true;
                  auto_apply_diff_after_generation = false;
                  support_paste_from_clipboard = false;
                  minimize_diff = true;
                  enable_token_counting = true;
                  enable_claude_text_editor_tool_mode = false;
                };
              }
              cfg.avante.customConfig
            ];
          };
        };
      };
    };
  };
}

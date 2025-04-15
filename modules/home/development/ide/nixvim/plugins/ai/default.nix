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
  inherit (lib.${namespace}) mkEnumOption mkStrOption;

  # Check if AI is enabled at the OS level.
  osEnabledAI = config.${namespace}.development.ai.enable;

  # Define presets for Avante AI plugin.
  avantePresets = {
    "gemini" = {
      provider = "gemini";
      auto_suggestions_provider = "gemini";
      gemini = {
        endpoint = "https://generativelanguage.googleapis.com/v1beta/models";
        model = cfg.avante.reasoningModel;
        timeout = 30000;
        temperature = 0;
        max_tokens = 20480;
      };
    };
  };
in
{
  # Define the options for this module.
  options.${namespace}.development.ide.nixvim.plugins.ai = {
    # Enable AI plugins for NixVim.
    enable = mkEnableOption "Enable AI plugins for NixVim";
    # Configuration options for the Avante AI plugin.
    avante = {
      # Select a preset for Avante.
      preset = mkEnumOption [ "gemini" ] "gemini" "Preset";
      # Specify the reasoning model for Avante.
      reasoningModel = mkStrOption "gemini-2.0-flash" "Reasoning Model";
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
        # Configure plugins.
        plugins = {
          # Configure Avante AI plugin.
          avante = {
            enable = true;
            settings = {
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
            } // avantePresets.${cfg.avante.preset};
          };
        };
      };
    };
  };
}

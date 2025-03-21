{
  namespace,
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.${namespace}.development.ide.nixvim.plugins.ai;
  inherit (lib) mkEnableOption mkIf;

  osEnabledAI = config.${namespace}.development.ai.enable;
in
{
  options.${namespace}.development.ide.nixvim.plugins.ai = {
    enable = mkEnableOption "Enable AI plugins for NixVim";
  };
  config = mkIf (cfg.enable && osEnabledAI) {
    programs = {
      nixvim = {
        extraConfigLuaPre = ''
          vim.g.tabby_agent_start_command = {"${pkgs.tabby-agent}/bin/tabby-agent", "--stdio", "--lsp"}
          vim.g.tabby_inline_completion_trigger = "auto"
          vim.g.tabby_inline_completion_keybinding_accept = "<s-cr>"
        '';
        extraPlugins = [
          pkgs.vimPlugins.vim-tabby
        ];
        plugins = {
          avante = {
            enable = true;
            settings = {
              provider = "gemini";
              auto_suggestions_provider = "gemini";
              cursor_applying_provider = "groq";
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
              gemini = {
                endpoint = "https://generativelanguage.googleapis.com/v1beta/models";
                model = "gemini-2.5-pro-exp-03-25";
                timeout = 30000;
                temperature = 0;
                max_tokens = 20480;
              };
            };
          };
        };
      };
    };
  };
}

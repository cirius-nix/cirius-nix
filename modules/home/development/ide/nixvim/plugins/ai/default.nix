{
  namespace,
  lib,
  config,
  ...
}:
let
  cfg = config.${namespace}.development.ide.nixvim.plugins.ai;
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.${namespace}) mkEnumOption mkAttrsOption;

  osEnabledAI = config.${namespace}.development.ai.enable;

  avanteProviders = {
    "gemini" = "gemini";
    "groq" = "groq";
    "deepseek" = "deepseek";
    "qwen" = "qianwen";
    "ollama" = "ollama";
  };
in
{
  options.${namespace}.development.ide.nixvim.plugins.ai = {
    enable = mkEnableOption "Enable AI plugins for NixVim";
    avante = {
      provider = mkEnumOption [ "gemini" "groq" "deepseek" "ollama" "qwen" ] "gemini" "provider";
      customConfig = mkAttrsOption lib.types.anything { } "Custom vendors";
    };
  };
  config = mkIf (cfg.enable && osEnabledAI) {
    # ${namespace}.developpment.ide.nixvim.plugins.completion.tabAutocompleteSources = [
    #   "avante"
    # ];
    programs = {
      nixvim = {
        keymaps = [ ];
        # blink-cmp-avante = {
        #   settings = [ ];
        # };
        # blink-cmp = {
        #   settings = {
        #     sources = {
        #       providers = {
        #         avante = {
        #           module = "blink-cmp-avante";
        #           name = "Avante";
        #           opts = { };
        #         };
        #       };
        #     };
        #   };
        # };
        plugins = {
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

{
  namespace,
  lib,
  config,
  ...
}:
let
  cfg = config.${namespace}.development.ide.nixvim.plugins.ai;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.${namespace}.development.ide.nixvim.plugins.ai = {
    enable = mkEnableOption "Enable AI plugins for NixVim";
    codeium = mkEnableOption "Enable codeium";
    enableCopilotChat = mkEnableOption "Enable Copilot Chat plugin";
  };
  config = mkIf cfg.enable {
    programs.nixvim.plugins = {
      codeium-nvim = {
        enable = cfg.codeium;
      };
      copilot-chat = {
        enable = false;
      };
      copilot-cmp = {
        enable = lib.mkForce cfg.enableCopilotChat;
      };
      copilot-lua = {
        enable = cfg.enableCopilotChat;
        panel = {
          enabled = false;
        };
        suggestion = {
          enabled = false;
        };
      };
    };
  };
}

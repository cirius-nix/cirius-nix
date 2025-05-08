{
  config,
  namespace,
  lib,
  ...
}:
let
  cfg = config.${namespace}.development.ai.mistral;
  nixvimCfg = config.${namespace}.development.ide.nixvim;
  inherit (lib) mkIf mkEnableOption;
  inherit (lib.${namespace}) mkStrOption;
in
{
  options.${namespace}.development.ai.mistral = {
    enable = mkEnableOption "Enable Mistral AI";
    local = mkEnableOption "Enable local model support";
    model = mkStrOption "codestral-latest" "Model name";
    secretName = mkStrOption "mistral_auth_token" "SOPS secrets name";
    tabbyIntegration = {
      enable = mkEnableOption "Enable tabby integration";
      model = {
        chat = mkStrOption "codestral-latest" "Chat model";
        completion = mkStrOption "codestral-latest" "Completion model";
      };
    };
    nixvimIntegration = {
      enable = mkEnableOption "Enable Nixvim integration";
    };
  };
  config = mkIf cfg.enable {
    sops = mkIf (cfg.secretName != "") {
      secrets.${cfg.secretName} = {
        mode = "0440";
      };
    };
    programs.nixvim = mkIf (nixvimCfg.enable && cfg.nixvimIntegration.enable) {
      extraConfigLua = ''
        _G.FUNCS.load_secret("MISTRAL_API_KEY", "${config.sops.secrets."mistral_auth_token".path}")
      '';
    };
    ${namespace}.development.ai.tabby = mkIf (cfg.tabbyIntegration.enable) {
      model = {
        chat = {
          kind = "mistral/chat";
          model_name = cfg.tabbyIntegration.model.chat;
          api_endpoint = "https://codestral.mistral.ai/v1/chat/completions";
          api_key = config.sops.placeholder.${cfg.secretName};
        };
        completion = {
          kind = "mistral/completion";
          model_name = cfg.tabbyIntegration.model.completion;
          api_endpoint = "https://codestral.mistral.ai/v1/fim/completions";
          api_key = config.sops.placeholder.${cfg.secretName};
        };
      };
    };
  };
}

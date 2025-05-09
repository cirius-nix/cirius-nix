{
  config,
  namespace,
  lib,
  ...
}:
let
  cfg = config.${namespace}.development.ai.deepinfra;
  nixvimCfg = config.${namespace}.development.ide.nixvim;
  inherit (lib) mkIf mkEnableOption;
  inherit (lib.${namespace}) mkStrOption;
in
{
  options.${namespace}.development.ai.deepinfra = {
    enable = mkEnableOption "Enable deepinfra AI";
    local = mkEnableOption "Enable local model support";
    secretName = mkStrOption "deepinfra_auth_token" "SOPS secrets name";
    tabbyIntegration = {
      enable = mkEnableOption "Enable tabby integration";
      completionFIMTemplate = mkStrOption "" "FIM template";
      model = {
        chat = mkStrOption "" "Chat model";
        completion = mkStrOption "" "Completion model";
        embedding = mkStrOption "" "Embedding model";
      };
    };
    nixvimIntegration = {
      enable = mkEnableOption "Enable Nixvim integration";
      model = mkStrOption "" "Nixvim model name";
    };
    opencommitIntegration = {
      enable = mkEnableOption "Enable opencommit integration";
      model = mkStrOption "" "Opencommit integration";
    };
  };

  config = {
    sops = mkIf (cfg.secretName != "") {
      secrets.${cfg.secretName} = {
        mode = "0440";
      };
    };
    programs.nixvim = mkIf (nixvimCfg.enable && cfg.nixvimIntegration.enable) {
      extraConfigLua = ''
        _G.FUNCS.load_secret("deepinfra_API_KEY", "${config.sops.secrets."deepinfra_auth_token".path}")
      '';
    };
    ${namespace}.development = {
      ai.tabby = mkIf cfg.tabbyIntegration.enable {
        model = {
          chat = mkIf (cfg.tabbyIntegration.model.chat != "") {
            kind = "openai/chat";
            model_name = cfg.tabbyIntegration.model.chat;
            api_endpoint = "https://api.deepinfra.com/v1/openai";
            api_key = config.sops.placeholder.${cfg.secretName};
          };
          completion = mkIf (cfg.tabbyIntegration.model.completion != "") {
            kind = "openai/completion";
            model_name = cfg.tabbyIntegration.model.completion;
            api_endpoint = "https://api.deepinfra.com/v1/openai";
            api_key = config.sops.placeholder.${cfg.secretName};
          };
          embedding = mkIf (cfg.tabbyIntegration.model.embedding != "") {
            kind = "openai/embedding";
            model_name = cfg.tabbyIntegration.model.embedding;
            api_endpoint = "https://api.deepinfra.com/v1/openai";
            api_key = config.sops.placeholder.${cfg.secretName};
          };
        };
      };
      git = mkIf cfg.opencommitIntegration.enable {
        opencommit = {
          customConfig = ''
            OCO_AI_PROVIDER=openai
            OCO_API_URL="https://api.deepinfra.com/v1/openai"
            OCO_MODEL=${cfg.opencommitIntegration.model}
            OCO_API_KEY=${config.sops.placeholder.${cfg.secretName}}
          '';
        };
      };
      ide.nixvim.plugins.ai.avante = mkIf (nixvimCfg.enable && cfg.nixvimIntegration.enable) {
        customConfig = {
          vendors = {
            deepinfra = {
              __inherited_from = "openai";
              api_key_name = "deepinfra_API_KEY";
              endpoint = "https://api.deepinfra.com/v1/openai";
              model = cfg.nixvimIntegration.model;
              timeout = 30000;
              temperature = 0;
              max_tokens = 8192;
            };
          };
        };
      };
    };
  };
}

{
  config,
  namespace,
  lib,
  ...
}:
let
  cfg = config.${namespace}.development.ai.groq;
  nixvimCfg = config.${namespace}.development.ide.nixvim;
  inherit (lib) mkIf mkEnableOption;
  inherit (lib.${namespace}) mkStrOption;
in
{
  options.${namespace}.development.ai.groq = {
    enable = mkEnableOption "Enable groq AI";
    model = mkStrOption "deepseek-r1-distill-llama-70b" "Model name";
    secretName = mkStrOption "groq_auth_token" "SOPS secrets name";
    nixvimIntegration = {
      enable = mkEnableOption "Enable Nixvim integration";
      model = mkStrOption "deepseek-r1-distill-llama-70b" "Nixvim model name";
    };
    opencommitIntegration = {
      enable = mkEnableOption "Enable opencommit integration";
      model = mkStrOption "deepseek-r1-distill-llama-70b" "Opencommit integration";
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
        _G.FUNCS.load_secret("GROQ_API_KEY", "${config.sops.secrets."groq_auth_token".path}")
      '';
    };
    ${namespace}.development = {
      git = mkIf cfg.opencommitIntegration.enable {
        opencommit = {
          customConfig = ''
            OCO_AI_PROVIDER=groq
            OCO_MODEL=${cfg.opencommitIntegration.model}
            OCO_API_KEY=${config.sops.placeholder.${cfg.secretName}}
          '';
        };
      };

      ide.nixvim.plugins.ai.avante = mkIf (nixvimCfg.enable && cfg.nixvimIntegration.enable) {
        customConfig = {
          providers = {
            groq = {
              __inherited_from = "openai";
              endpoint = "https://api.groq.com/openai/v1/";
              api_key_name = "GROQ_API_KEY";
              model = cfg.nixvimIntegration.model;
              extra_request_body = {
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

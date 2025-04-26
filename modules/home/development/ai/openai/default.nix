{
  config,
  namespace,
  lib,
  ...
}:
let
  cfg = config.${namespace}.development.ai.openai;
  nixvimCfg = config.${namespace}.development.ide.nixvim;
  inherit (lib) mkIf mkEnableOption;
  inherit (lib.${namespace}) mkStrOption;
in
{
  options.${namespace}.development.ai.openai = {
    enable = mkEnableOption "Enable openai AI";
    model = mkStrOption "gpt-4o" "Model name";
    secretName = mkStrOption "openai_auth_token" "SOPS secrets name";
    tabbyIntegration = mkEnableOption "Enable Tabby integration";
    nixvimIntegration = {
      enable = mkEnableOption "Enable Nixvim integration";
      model = mkStrOption "gpt-4o" "Nixvim model name";
    };
    opencommitIntegration = {
      enable = mkEnableOption "Enable opencommit integration";
      model = mkStrOption "gpt-4o" "Opencommit integration";
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
        _G.FUNCS.load_secret("OPENAI_API_KEY", "${config.sops.secrets."openai_auth_token".path}")
      '';
    };
    ${namespace}.development = {
      git = mkIf cfg.opencommitIntegration.enable {
        opencommit = {
          customConfig = ''
            OCO_AI_PROVIDER=openai
            OCO_MODEL=${cfg.opencommitIntegration.model}
            OCO_API_KEY=${config.sops.placeholder.${cfg.secretName}}
          '';
        };
      };

      ide.nixvim.plugins.ai.avante = mkIf (nixvimCfg.enable && cfg.nixvimIntegration.enable) {
        customConfig = {
          openai = {
            endpoint = "https://api.openai.com/v1";
            api_key_name = "OPENAI_API_KEY";
            model = cfg.nixvimIntegration.model;
            timeout = 30000;
            temperature = 0;
            max_tokens = 20480;
          };
        };
      };
    };
  };
}

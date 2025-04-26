{
  config,
  namespace,
  lib,
  ...
}:
let
  cfg = config.${namespace}.development.ai.gemini;
  nixvimCfg = config.${namespace}.development.ide.nixvim;
  inherit (lib) mkIf mkEnableOption;
  inherit (lib.${namespace}) mkStrOption;

in
{
  options.${namespace}.development.ai.gemini = {
    enable = mkEnableOption "Enable Gemini AI";
    local = mkEnableOption "Enable local model support";
    model = mkStrOption "" "Model name";
    secretName = mkStrOption "gemini_auth_token" "SOPS secrets name";
    nixvimIntegration = {
      enable = mkEnableOption "Enable Nixvim integration";
      model = mkStrOption "gemini-2.0-flash" "Nixvim model name";
    };
    opencommitIntegration = {
      enable = mkEnableOption "Enable opencommit integration";
      model = mkStrOption "gemini-2.0-flash" "Opencommit integration";
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
        _G.FUNCS.load_secret("GEMINI_API_KEY", "${config.sops.secrets."gemini_auth_token".path}")
      '';
    };
    ${namespace}.development = {
      git = mkIf cfg.opencommitIntegration.enable {
        opencommit = {
          customConfig = ''
            OCO_AI_PROVIDER=gemini
            OCO_MODEL=${cfg.opencommitIntegration.model}
            OCO_API_KEY=${config.sops.placeholder.${cfg.secretName}}
          '';
        };
      };
      ide.nixvim.plugins.ai.avante = mkIf (nixvimCfg.enable && cfg.nixvimIntegration.enable) {
        customConfig = {
          gemini = {
            endpoint = "https://generativelanguage.googleapis.com/v1beta/models";
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

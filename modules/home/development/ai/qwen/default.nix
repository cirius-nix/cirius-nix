{
  config,
  namespace,
  lib,
  ...
}:
let
  cfg = config.${namespace}.development.ai.qwen;
  nixvimCfg = config.${namespace}.development.ide.nixvim;
  inherit (lib) mkIf mkEnableOption;
  inherit (lib.${namespace}) mkStrOption;
in
{
  options.${namespace}.development.ai.qwen = {
    enable = mkEnableOption "Enable qwen AI";
    local = mkEnableOption "Enable local model support";
    model = mkStrOption "qwen2.5-72b-instruct" "Model";
    secretName = mkStrOption "qwen_auth_token" "SOPS secrets name";
    nixvimIntegration = {
      enable = mkEnableOption "Enable Nixvim integration";
      model = mkStrOption "qwen2.5-72b-instruct" "Nixvim model name";
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
        _G.FUNCS.load_secret("DASHSCOPE_API_KEY", "${config.sops.secrets."qwen_auth_token".path}")
      '';
    };
    ${namespace}.development.ide.nixvim.plugins.ai.avante =
      mkIf (nixvimCfg.enable && cfg.nixvimIntegration.enable)
        {
          customConfig = {
            providers = {
              qianwen = {
                __inherited_from = "openai";
                api_key_name = "DASHSCOPE_API_KEY";
                endpoint = "https://dashscope-intl.aliyuncs.com/compatible-mode/v1";
                model = cfg.nixvimIntegration.model;
                extra_request_body = {
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

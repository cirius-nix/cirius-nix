{
  config,
  namespace,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (lib.${namespace}) mkStrOption;

  inherit (config.${namespace}.development.ai) qwen;
  inherit (config.${namespace}.development.ide) nixvim;
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
  config = mkIf qwen.enable {
    sops = mkIf (qwen.secretName != "") {
      secrets.${qwen.secretName} = {
        mode = "0440";
      };
    };
    programs.nixvim = mkIf (nixvim.enable && qwen.nixvimIntegration.enable) {
      extraConfigLua = ''
        _G.FUNCS.load_secret("DASHSCOPE_API_KEY", "${config.sops.secrets."qwen_auth_token".path}")
      '';
    };
    ${namespace}.development.ide.nixvim.plugins.ai.avante =
      mkIf (nixvim.enable && qwen.nixvimIntegration.enable)
        {
          customConfig = {
            providers = {
              qianwen = {
                __inherited_from = "openai";
                api_key_name = "DASHSCOPE_API_KEY";
                endpoint = "https://dashscope-intl.aliyuncs.com/compatible-mode/v1";
                model = qwen.nixvimIntegration.model;
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

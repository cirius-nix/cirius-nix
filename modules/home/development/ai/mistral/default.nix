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
    # TODO: integrate with tabby
    tabbyIntegration = mkEnableOption "Enable Tabby integration";
    nixvimIntegration = mkEnableOption "Enable Nixvim integration";
  };
  config = mkIf cfg.enable {
    sops = mkIf (cfg.secretName != "") {
      secrets.${cfg.secretName} = {
        mode = "0440";
      };
    };
    programs.nixvim = mkIf (nixvimCfg.enable) {
      extraConfigLua = ''
        _G.FUNCS.load_secret("MISTRAL_API_KEY", "${config.sops.secrets."mistral_auth_token".path}")
      '';
    };
  };
}

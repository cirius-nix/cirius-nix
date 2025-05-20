{
  config,
  namespace,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption optionalAttrs;
  inherit (lib.${namespace}) mkStrOption mkListOption;

  mistral = config.${namespace}.development.ai.mistral;
  nixvim = config.${namespace}.development.ide.nixvim;
in
{
  options.${namespace}.development.ai.mistral = {
    enable = mkEnableOption "Enable Mistral AI";
    local = mkEnableOption "Enable local model support";
    model = mkStrOption "codestral-latest" "Model name";
    secretName = mkStrOption "mistral_auth_token" "SOPS secret name";
    codestralSecretName = mkStrOption "codestral_auth_token" "SOPS secret name";
    continueIntegration = {
      enable = mkEnableOption "Enable continue plugin integration";
      models = {
        completion = mkStrOption "" "Auto complete model";
        embedding = mkStrOption "" "Embedding model";
        chat = mkListOption lib.types.str [ ] "List of model";
      };
    };
    tabbyIntegration = {
      enable = mkEnableOption "Enable tabby integration";
      model = {
        chat = mkStrOption "" "Chat model";
        completion = mkStrOption "" "Completion model";
      };
    };
    nixvimIntegration = {
      enable = mkEnableOption "Enable Nixvim integration";
    };
  };
  config = mkIf mistral.enable {
    sops.secrets =
      { }
      // (optionalAttrs (mistral.secretName != "") {
        ${mistral.secretName} = {
          mode = "0440";
        };
      })
      // (optionalAttrs (mistral.codestralSecretName != "") {
        ${mistral.codestralSecretName} = {
          mode = "0440";
        };
      });

    programs.nixvim = mkIf (nixvim.enable && mistral.nixvimIntegration.enable) {
      extraConfigLua = ''
        _G.FUNCS.load_secret("MISTRAL_API_KEY", "${
          config.sops.secrets.${mistral.codestralSecretName}.path
        }")
      '';
    };

    ${namespace} = {
      development = {
        ide.vscode = mkIf config.${namespace}.development.ide.vscode.enable {
          continue = mkIf mistral.continueIntegration.enable (
            let
              autoCompleteModel = mkIf (mistral.continueIntegration.models.completion != "") {
                provider = "mistral";
                title = "mistral/" + mistral.continueIntegration.models.completion;
                model = mistral.continueIntegration.models.completion;
                apiKey = config.sops.placeholder.${mistral.codestralSecretName};
                apiBase = "https://codestral.mistral.ai/v1";
              };

              embeddingModel = mkIf (mistral.continueIntegration.models.embedding != "") {
                provider = "mistral";
                title = "mistral/" + mistral.continueIntegration.models.embedding;
                model = mistral.continueIntegration.models.embedding;
                apiKey = config.sops.placeholder.${mistral.codestralSecretName};
                apiBase = "https://codestral.mistral.ai/v1";
              };

              chatModels = builtins.map (modelName: {
                provider = "mistral";
                title = "mistral/" + modelName;
                model = modelName;
                apiKey = config.sops.placeholder.${mistral.codestralSecretName};
                apiBase = "https://codestral.mistral.ai/v1";
              }) mistral.continueIntegration.models.chat;
            in
            {
              autoCompleteModel = autoCompleteModel;
              embeddingModel = embeddingModel;
              chatModels = chatModels;
            }
          );
        };
        ai.tabby = mkIf (mistral.tabbyIntegration.enable) {
          model = {
            chat = mkIf (mistral.tabbyIntegration.model.chat != "") {
              kind = "mistral/chat";
              model_name = mistral.tabbyIntegration.model.chat;
              api_endpoint = "https://codestral.mistral.ai";
              api_key = config.sops.placeholder.${mistral.codestralSecretName};
            };
            completion = mkIf (mistral.tabbyIntegration.model.completion != "") {
              kind = "mistral/completion";
              model_name = mistral.tabbyIntegration.model.completion;
              api_endpoint = "https://codestral.mistral.ai";
              api_key = config.sops.placeholder.${mistral.codestralSecretName};
            };
          };
        };
      };
    };
  };
}

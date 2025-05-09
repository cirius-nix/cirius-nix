{
  config,
  osConfig,
  namespace,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.${namespace}.development.ai.ollama;
  nixvimCfg = config.${namespace}.development.ide.nixvim;
  inherit (lib) mkIf mkEnableOption;
  inherit (lib.${namespace}) mkStrOption mkListOption;
  inherit (pkgs.stdenv) isLinux;
  aiModuleCfg = config.${namespace}.development.ai;
  osAiModuleCfg = osConfig.${namespace}.applications.ai;
  port = if isLinux then osAiModuleCfg.port else aiModuleCfg.port;
in
{
  options.${namespace}.development.ai.ollama = {
    enable = mkEnableOption "Enable ollama AI";
    continueIntegration = {
      enable = mkEnableOption "Enable continue plugin integration";
      models = {
        completion = mkStrOption "" "Auto complete model";
        embedding = mkStrOption "" "Embedding model";
        chat = mkListOption lib.types.str [ ] "List of model";
      };
    };
    nixvimIntegration = {
      enable = mkEnableOption "Enable Nixvim integration";
      model = mkStrOption "smallthinker" "Nixvim model name";
    };
    opencommitIntegration = {
      enable = mkEnableOption "Enable opencommit integration";
      model = mkStrOption "smallthinker" "Opencommit integration";
    };
    tabbyIntegration = {
      enable = mkEnableOption "Enable tabby integration";
      completionFIMTemplate = mkStrOption "" "FIM template";
      model = {
        chat = mkStrOption "" "Chat model";
        completion = mkStrOption "" "Completion model";
        embedding = mkStrOption "" "Embedding model";
      };
    };
  };

  config = {
    ${namespace}.development = {
      ai.tabby = mkIf cfg.tabbyIntegration.enable {
        model = {
          chat = mkIf (cfg.tabbyIntegration.model.chat != "") {
            kind = "openai/chat";
            model_name = cfg.tabbyIntegration.model.chat;
            api_endpoint = "http://localhost:${builtins.toString port}";
          };
          completion = mkIf (cfg.tabbyIntegration.model.completion != "") {
            kind = "ollama/completion";
            api_endpoint = "http://localhost:${builtins.toString port}";
            model_name = cfg.tabbyIntegration.model.completion;
            prompt_template = cfg.tabbyIntegration.completionFIMTemplate;
          };
          embedding = mkIf (cfg.tabbyIntegration.model.completion != "") {
            kind = "ollama/embedding";
            model_name = cfg.tabbyIntegration.model.embedding;
            api_endpoint = "http://localhost:${builtins.toString port}";
          };
        };
      };
      cli-utils.fish = {
        interactiveEnvs = {
          OLLAMA_HOST = "localhost:${builtins.toString port}";
        };
      };
      git = mkIf cfg.opencommitIntegration.enable {
        opencommit = {
          customConfig = ''
            OCO_AI_PROVIDER=ollama
            OCO_MODEL=${cfg.opencommitIntegration.model}
            OCO_API_URL=http://localhost:${builtins.toString port}/api/chat
          '';
        };
      };
      ide = {
        vscode.continue = mkIf cfg.continueIntegration.enable (
          let
            apiBase = "http://localhost:${builtins.toString port}";
          in
          {
            autoCompleteModel = mkIf (cfg.continueIntegration.models.completion != "") {
              provider = "ollama";
              title = "ollama/" + cfg.continueIntegration.models.completion;
              model = cfg.continueIntegration.models.completion;
              apiBase = apiBase;
            };
            embeddingModel = mkIf (cfg.continueIntegration.models.embedding != "") {
              provider = "ollama";
              model = cfg.continueIntegration.models.embedding;
              apiBase = apiBase;
            };
            chatModels = builtins.map (modelName: {
              provider = "ollama";
              title = "ollama/" + modelName;
              model = modelName;
              apiBase = apiBase;
            }) cfg.continueIntegration.models.chat;
          }
        );
        nixvim.plugins.ai.avante = mkIf (nixvimCfg.enable && cfg.nixvimIntegration.enable) {
          customConfig = {
            ollama =
              let
                endpoint = "http://localhost:${builtins.toString port}";
              in
              {
                endpoint = endpoint;
                model = cfg.nixvimIntegration.model;
                timeout = 30000;
                temperature = 0;
                max_tokens = 20480;
              };
          };
        };
      };
    };
  };
}

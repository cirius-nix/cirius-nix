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
  inherit (lib.${namespace}) mkStrOption;
  inherit (pkgs.stdenv) isLinux;
  aiModuleCfg = config.${namespace}.development.ai;
  osAiModuleCfg = osConfig.${namespace}.applications.ai;
  port = if isLinux then osAiModuleCfg.port else aiModuleCfg.port;
in
{
  options.${namespace}.development.ai.ollama = {
    enable = mkEnableOption "Enable ollama AI";
    model = mkStrOption "cogito:8b-v1-preview-llama-q4_K_M" "Model name";
    nixvimIntegration = {
      enable = mkEnableOption "Enable Nixvim integration";
      model = mkStrOption "cogito:8b-v1-preview-llama-q4_K_M" "Nixvim model name";
    };
    opencommitIntegration = {
      enable = mkEnableOption "Enable opencommit integration";
      model = mkStrOption "cogito:8b-v1-preview-llama-q4_K_M" "Opencommit integration";
    };
    tabbyIntegration = {
      enable = mkEnableOption "Enable tabby integration";
      completionFIMTemplate = mkStrOption "<|fim_prefix|>{prefix}<|fim_suffix|>{suffix}<|fim_middle|>" "FIM template";
      model = {
        chat = mkStrOption "cogito:8b-v1-preview-llama-q4_K_M" "Chat model";
        completion = mkStrOption "codegemma:3b-code-q4_K_M" "Completion model";
        embedding = mkStrOption "nomic-embed-text:latest" "Embedding model";
      };
    };
  };

  config = {
    ${namespace}.development = {
      ai.tabby = mkIf (cfg.tabbyIntegration.enable) {
        model = {
          chat = {
            kind = "openai/chat";
            model_name = cfg.tabbyIntegration.model.chat;
            api_endpoint = "http://localhost:${builtins.toString port}";
          };
          completion = {
            kind = "ollama/completion";
            api_endpoint = "http://localhost:${builtins.toString port}";
            model_name = cfg.tabbyIntegration.model.completion;
            prompt_template = cfg.tabbyIntegration.completionFIMTemplate;
          };
          embedding = {
            kind = "ollama/embedding";
            model_name = cfg.tabbyIntegration.model.embedding;
            api_endpoint = "http://localhost:${builtins.toString port}";
          };
        };
      };
      cli-utils.fish = {
        interactiveEnvs = {
          OLLAMA_HOST = "127.0.0.1:${builtins.toString port}";
        };
      };
      git = mkIf cfg.opencommitIntegration.enable {
        opencommit = {
          customConfig = ''
            OCO_AI_PROVIDER=ollama
            OCO_MODEL=${cfg.opencommitIntegration.model}
            OCO_API_URL=http://0.0.0.0:${builtins.toString port}/api/chat
          '';
        };
      };
      ide.nixvim.plugins.ai.avante = mkIf (nixvimCfg.enable && cfg.nixvimIntegration.enable) {
        customConfig = {
          ollama =
            let
              endpoint = "http://127.0.0.1:${builtins.toString port}";
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
}

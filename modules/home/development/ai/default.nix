{
  config,
  namespace,
  lib,
  osConfig,
  pkgs,
  ...
}:
let

  isLinux = pkgs.stdenv.isLinux;
  isDarwin = pkgs.stdenv.isDarwin;

  cfg = config.${namespace}.development.ai;
  osCfg = osConfig.${namespace}.applications.ai;

  inherit (lib.${namespace}) mkIntOption;

  port = if isLinux then osCfg.port else cfg.port;
  defaultOllamaPort = 11000;
in
{
  options.${namespace}.development.ai = {
    enable = lib.mkEnableOption "Toggle AI Development Tools (Tabby, Aider, etc.)";
    port = mkIntOption defaultOllamaPort "Ollama Service Port (used on macOS if enabled here)";
  };

  config = lib.mkIf cfg.enable {
    sops =
      let
        commonSecretConfig = {
          mode = "0440";
        };
      in
      {
        secrets."openai_auth_token" = commonSecretConfig;
        secrets."deepseek_auth_token" = commonSecretConfig;
        secrets."gemini_auth_token" = commonSecretConfig;
        secrets."groq_auth_token" = commonSecretConfig;
        secrets."qwen_auth_token" = commonSecretConfig;
        secrets."tabby_auth_token" = commonSecretConfig;
      };

    ${namespace}.development.cli-utils.fish = {
      interactiveEnvs = {
        OLLAMA_HOST = "127.0.0.1:${builtins.toString port}";
      };
    };

    home = {
      packages =
        with pkgs;
        lib.flatten [
          [
            tabby
            tabby-agent
            katana
            aider-chat-full
          ]
          (lib.optional isLinux [
            lmstudio
            python313Packages.peft
            python313Packages.transformers
            python313Packages.bitsandbytes
          ])
        ];

    };

    services = lib.mkIf isDarwin {
      ollama = {
        enable = true;
        port = port;
        acceleration = null;
      };
    };
  };
}

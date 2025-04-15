{
  config,
  namespace,
  lib,
  osConfig,
  pkgs,
  ...
}:
let
  # Basic flags and configuration values.
  isLinux = pkgs.stdenv.isLinux;
  isDarwin = pkgs.stdenv.isDarwin;
  cfg = config.${namespace}.development.ai;
  osAICfg = osConfig.${namespace}.applications.ai;
  userCfg = config.${namespace}.user;
  enabledNvidia = osConfig.${namespace}.gpu-drivers.nvidia.enable;

  # library functions.
  inherit (lib.${namespace})
    mkIntOption
    mkAttrsOption
    mkListOption
    mkStrOption
    subModuleType
    ;

  # OS-specific configuration.
  osCfg = {
    port = if isLinux then osAICfg.port else cfg.port;
    tabby = cfg.tabby;
  };

  # Build a string representation from an attribute set.
  attrsToString =
    attrs:
    let
      keys = builtins.attrNames attrs;
      keyValues = map (k: "${k} = \"${attrs.${k}}\"") keys;
    in
    builtins.concatStringsSep "\n" keyValues;

  # Create a local repositories string from a list of repository objects.
  mkLocalRepositories =
    repositories:
    builtins.concatStringsSep "\n" (
      map (r: ''
        [[repositories]]
        name = "${r.name}"
        git_url = "file:///${r.repo}"
      '') repositories
    );

  # Determine the device argument based on the OS and enabled GPU options.
  deviceArg =
    if isDarwin then
      "--device metal"
    else if enabledNvidia then
      "--device cuda"
    else
      "";
in
{
  options.${namespace}.development.ai =
    let
      ollamaPort = 11000;
    in
    {
      enable = lib.mkEnableOption "Toggle AI Tools";
      port = mkIntOption ollamaPort "Ollama Port";
      tabby = {
        port = mkIntOption 11001 "Port";
        localRepos = mkListOption (subModuleType {
          name = mkStrOption "" "Name of repository";
          repo = mkStrOption "" "Repositories";
        }) [ ] "Local repositories for preloading";
        model = {
          chat = mkAttrsOption lib.types.str {
            kind = "openai/chat";
            model_name = "qwen2.5-coder:7b-instruct";
            api_endpoint = "http://localhost:${builtins.toString ollamaPort}/v1";
          } "Chat model";
          completion = mkAttrsOption lib.types.str {
            kind = "ollama/completion";
            api_endpoint = "http://localhost:${builtins.toString ollamaPort}";
            model_name = "qwen2.5-coder:7b-base";
            prompt_template = "<|fim_prefix|> {prefix} <|fim_suffix|>{suffix} <|fim_middle|>";
          } "Completion model";
          embedding = mkAttrsOption lib.types.str {
            kind = "ollama/embedding";
            model_name = "nomic-embed-text:latest";
            api_endpoint = "http://localhost:${builtins.toString ollamaPort}";
          } "Embedding model";
        };
      };
    };

  config = lib.mkIf cfg.enable {
    sops = {
      secrets."openai_auth_token" = { };
      secrets."deepseek_auth_token" = { };
      secrets."gemini_auth_token" = { };
      secrets."tabby_auth_token" = { };
      templates."tabby-agent-config" = {
        path = "${userCfg.homeDir}/.tabby-client/agent/config.toml";
        content = ''
          [server]
          endpoint = "http://localhost:${builtins.toString osCfg.tabby.port}"
          token = "${config.sops.placeholder."tabby_auth_token"}"

          [logs]
          level = "info"

          [anonymousUsageTracking]
          disable = true
        '';
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
            lmstudio # INFO: marked as broken in macOS
            python313Packages.peft
            python313Packages.transformers
            python313Packages.bitsandbytes
          ])
        ];
      file =
        let
          chatModelCfg = attrsToString osCfg.tabby.model.chat;
          embeddingCfg = attrsToString osCfg.tabby.model.embedding;
          completionCfg = attrsToString osCfg.tabby.model.completion;
        in
        {
          ".tabby/config.toml".text = ''
            [server]
            endpoint = "http://127.0.0.1:${builtins.toString osCfg.tabby.port}"
            completion_timeout = 15000

            ${lib.optionalString (chatModelCfg != "") ''
              [model.chat.http]
              ${chatModelCfg}
            ''}

            ${lib.optionalString (embeddingCfg != "") ''
              [model.embedding.http]
              ${embeddingCfg}
            ''}

            ${lib.optionalString (completionCfg != "") ''
              [model.completion.http]
              ${completionCfg}
            ''}

            ${mkLocalRepositories osCfg.tabby.localRepos}
          '';
        };
    };

    # For macOS, enable the AI service at the system level.
    services = lib.mkIf isDarwin {
      ollama = {
        enable = true;
        port = osCfg.port;
        acceleration = null;
      };
    };

    # Define the user-level systemd service for Tabby on Linux.
    systemd.user.services.tabby = {
      Unit = {
        Description = "User-level Tabby Service";
        After = [ "ollama.service" ];
      };
      Service = {
        Type = "simple";
        ExecStart = ''
          ${pkgs.tabby}/bin/tabby serve \
            --port ${builtins.toString osCfg.tabby.port} \
            ${deviceArg}
        '';
        Restart = "on-failure";
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
    };

    # Define the user-level launchd agent for Tabby on macOS.
    launchd.agents.tabby = {
      enable = true;
      config = {
        Label = "com.tabby.serve";
        ProgramArguments = [
          "${pkgs.tabby}/bin/tabby"
          "serve"
          "--port"
          (builtins.toString osCfg.tabby.port)
          "--device"
          "metal"
        ];
        RunAtLoad = true;
        KeepAlive = true;
        StandardOutPath = "/tmp/tabby.log";
        StandardErrorPath = "/tmp/tabby.err";
      };
    };

    ${namespace}.development.cli-utils.fish = {
      interactiveEnvs = {
        OLLAMA_HOST = "127.0.0.1:${builtins.toString osCfg.port}";
      };
      interactiveFuncs = {
        gemini_aider = ''
          set -fx GEMINI_API_KEY (cat ~/.config/sops-nix/secrets/gemini_auth_token)
          aider --model gemini-2.5-pro
        '';
      };
    };
  };

}

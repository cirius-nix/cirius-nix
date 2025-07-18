{
  config,
  namespace,
  lib,
  pkgs,
  osConfig,
  ...
}:
let
  isLinux = pkgs.stdenv.isLinux;
  isDarwin = pkgs.stdenv.isDarwin;

  cfg = config.${namespace}.development.ai.tabby;
  inherit (config.${namespace}.development.ide) nixvim;
  userCfg = config.${namespace}.user;

  inherit (lib) mkIf mkEnableOption;
  inherit (lib.${namespace})
    mkStrOption
    mkIntOption
    mkListOption
    mkAttrsOption
    subModuleType
    ;

  localRepoOptions = subModuleType {
    name = mkStrOption "" "Unique name for the repository in Tabby";
    repo = mkStrOption "" "Absolute path to the local Git repository";
  };
  defaultOllamaPort = 11000;
  mkSimpleTOMLKeyPairs =
    attrs:
    let
      keys = builtins.attrNames attrs;
      stringify =
        val:
        if builtins.isString val then
          "\"${val}\""
        else if builtins.isInt val then
          toString val
        else
          abort "Unsupported value type in attrsToString";
      keyValues = map (k: "${k} = ${stringify attrs.${k}}") keys;
    in
    builtins.concatStringsSep "\n" keyValues;

  mkLocalRepositories =
    repositories:
    builtins.concatStringsSep "\n" (
      map (r: ''
        [[repositories]]
        name = "${r.name}"
        git_url = "file:///${r.repo}"
      '') repositories
    );
in
{
  options.${namespace}.development.ai.tabby = {
    enable = mkEnableOption "Enable Tabby AI Agent";
    port = mkIntOption 11001 "Tabby Server Port";
    localRepos = mkListOption localRepoOptions [ ] "Local Git repositories for Tabby to index";
    enableNixvimIntegration = mkEnableOption "Enable Neovim Integration";
    model = {
      chat = mkAttrsOption lib.types.str {
        kind = "openai/chat";
        model_name = "qwen3:4b";
        api_endpoint = "http://localhost:${builtins.toString defaultOllamaPort}/v1";
      } "Tabby Chat Model Configuration";
      completion = mkAttrsOption lib.types.str {
        kind = "ollama/completion";
        api_endpoint = "http://localhost:${builtins.toString defaultOllamaPort}";
        model_name = "qwen2.5-coder:3b-base";
        prompt_template = "<|fim_prefix|> {prefix} <|fim_suffix|>{suffix} <|fim_middle|>";
      } "Tabby Completion Model Configuration";
      embedding = mkAttrsOption lib.types.str {
        kind = "ollama/embedding";
        model_name = "nomic-embed-text:latest";
        api_endpoint = "http://localhost:${builtins.toString defaultOllamaPort}";
      } "Tabby Embedding Model Configuration";
    };
  };

  config = mkIf cfg.enable {
    ${namespace}.development.ide.nixvim.plugins.completion.tabAutocompleteSources = mkIf (
      cfg.enableNixvimIntegration && nixvim.enable
    ) [ "cmp_tabby" ];

    home.packages = [
      pkgs.tabby
      pkgs.tabby-agent
    ];

    programs.nixvim.plugins = mkIf (cfg.enableNixvimIntegration && nixvim.enable) {
      cmp-tabby = {
        enable = true;
        settings = {
          host = "http://localhost:${builtins.toString cfg.port}";
        };
      };
      blink-cmp = {
        settings.sources = {
          providers = {
            cmp_tabby = {
              name = "cmp_tabby";
              module = "blink.compat.source";
              score_offset = -3;
            };
          };
        };
      };
    };
    sops = {
      secrets."tabby_auth_token" = {
        mode = "0440";
      };
      templates."tabby-config" = {
        mode = "0440";
        path = "${userCfg.homeDir}/.tabby/config.toml";
        content =
          let
            chatModelCfg = mkSimpleTOMLKeyPairs cfg.model.chat;
            embeddingCfg = mkSimpleTOMLKeyPairs cfg.model.embedding;
            completionCfg = mkSimpleTOMLKeyPairs cfg.model.completion;
          in
          ''
            [server]
            endpoint = "http://localhost:${builtins.toString cfg.port}"
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

            ${mkLocalRepositories cfg.localRepos}
          '';
      };

      templates."tabby-agent-config" = {
        path = "${userCfg.homeDir}/.tabby-client/agent/config.toml";
        content = ''
          [server]
          endpoint = "http://localhost:${builtins.toString cfg.port}"
          token = "${config.sops.placeholder."tabby_auth_token"}"

          [logs]
          level = "info"

          [anonymousUsageTracking]
          disable = true
        '';
      };
    };

    systemd.user.services.tabby = lib.mkIf isLinux {
      Unit = {
        Description = "User-level Tabby Service";
        After = [
          "network.target"
          "ollama.service"
          "sops-nix.service"
        ];
      };
      Service = {
        Type = "simple";
        ExecStart =
          let
            enabledNvidia = osConfig.${namespace}.gpu-drivers.nvidia.enable;
            deviceArg = if enabledNvidia then "--device cuda" else "";
          in
          ''
            ${pkgs.tabby}/bin/tabby serve \
              --port ${builtins.toString cfg.port} \
              ${deviceArg}
          '';
        Restart = "on-failure";
        RestartSec = "5s";
      };
      Install.WantedBy = [ "default.target" ];
    };
    launchd.agents.tabby = lib.mkIf isDarwin {
      enable = true;
      config = {
        Label = "com.tabby.serve";
        ProgramArguments = [
          "${pkgs.tabby}/bin/tabby"
          "serve"
          "--port"
          (builtins.toString cfg.port)
          "--device"
          "metal"
        ];
        RunAtLoad = true;
        KeepAlive = true;
        StandardOutPath = "/tmp/tabby-${config.${namespace}.user.name}.log";
        StandardErrorPath = "/tmp/tabby-${config.${namespace}.user.name}.err";
      };
    };
  };
}

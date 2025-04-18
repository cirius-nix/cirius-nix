{
  config,
  lib,
  pkgs,
  namespace,
  osConfig,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.${namespace}) mkStrOption mkEnumOption;

  cfg = config.${namespace}.development.git;
  userCfg = config.${namespace}.user;

  ollamaPort =
    let
      isLinux = pkgs.stdenv.isLinux;
      osAICfg = osConfig.${namespace}.applications.ai;
      homeAICfg = config.${namespace}.development.ai;
    in
    if isLinux then osAICfg.port else homeAICfg.port;

  opencommitSharedConfig = ''
    OCO_MODEL=${cfg.opencommit.model}
    OCO_PROMPT_MODULE=conventional-commit
    OCO_ONE_LINE_COMMIT=false
    OCO_WHY=true
    OCO_EMOJI=GitMoji
  '';

  opencommitPresets = {
    "ollama" = ''
      OCO_AI_PROVIDER=ollama
      OCO_API_URL=http://0.0.0.0:${builtins.toString ollamaPort}/api/chat
    '';
    "gemini" = ''
      OCO_AI_PROVIDER=gemini
      OCO_API_KEY=${config.sops.placeholder."gemini_auth_token"}
    '';
    "openai" = ''
      OCO_AI_PROVIDER=openai
      OCO_API_KEY=${config.sops.placeholder."openai_auth_token"}
    '';
    "deepseek" = ''
      OCO_AI_PROVIDER=deepseek
      OCO_API_KEY=${config.sops.placeholder."deepseek_auth_token"}
    '';
    "groq" = ''
      OCO_AI_PROVIDER=groq
      OCO_API_KEY=${config.sops.placeholder."groq_auth_token"}
    '';
  };

in
{
  options.${namespace}.development.git = {
    enable = mkEnableOption "Git";
    pager = mkEnableOption "Pager as paging package";
    opencommit = {
      preset = mkEnumOption [
        "ollama"
        "gemini"
        "openai"
        "deepseek"
        "groq"
      ] "ollama" "Opencommit Preset";
      model = mkStrOption "mistral:7b" "Model";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      gh
      delta
      diff-so-fancy
      opencommit
      gitmoji-cli
      commitlint
    ];

    sops.templates = {
      # opencommit allowed to read & write to this file.
      ".opencommit_provider_${cfg.opencommit.preset}" = {
        mode = "0660";
        path = "${config.${namespace}.user.homeDir}/.opencommit";
        content = ''
          ${opencommitPresets.${cfg.opencommit.preset}}
          ${opencommitSharedConfig}
        '';
      };
    };

    programs.lazygit = {
      inherit (cfg) enable;

      settings.git.paging = {
        pager = if cfg.pager then "delta --dark --syntax-theme 'Dracula' --paging=never" else "less";
      };
    };
    programs.git = {
      inherit (cfg) enable;
      userName = userCfg.username;
      userEmail = userCfg.email;

      aliases = {
        undo = "reset HEAD~1 --mixed";
        amend = "commit -a --amend";
        prv = "!gh pr view";
        prc = "!gh pr create";
        prs = "!gh pr status";
        prm = "!gh pr merge -d";
        pl = "pull";
        ps = "push";
        co = "checkout";
      };

      includes = [
        {
          condition = "gitdir:~/Workspace/github/personal/";
          path = "~/.gitconfig.personal";
        }
        {
          condition = "gitdir:~/Workspace/github/work/";
          path = "~/.gitconfig.work";
        }
      ];

      extraConfig = {
        core.whitespace = "trailing-space,space-before-tab";
        init.defaultBranch = "main";
        push.autoSetupRemote = true;
        color = {
          ui = "auto";
        };
        diff = {
          tool = "vimdiff";
          mnemonicprefix = true;
        };
        merge = {
          tool = "splice";
        };
        push = {
          default = "simple";
        };
        pull = {
          rebase = true;
        };
        branch = {
          autosetupmerge = true;
        };
        rerere = {
          enabled = true;
        };
        url."ssh://git@github.com/".insteadOf = "https://github.com/";
      };
    };
  };
}

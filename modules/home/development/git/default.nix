{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.${namespace}) mkStrOption mkListOption;

  cfg = config.${namespace}.development.git;
  userCfg = config.${namespace}.user;

  opencommitSharedConfig = ''
    OCO_PROMPT_MODULE=conventional-commit
    OCO_ONE_LINE_COMMIT=true
    OCO_WHY=true
    OCO_EMOJI=GitMoji
  '';
in
{
  options.${namespace}.development.git = {
    enable = mkEnableOption "Git";
    pager = mkEnableOption "Pager as paging package";
    opencommit = {
      customConfig = mkStrOption "" "Custom config";
    };
    includeConfigs = mkListOption lib.types.attrs [ ] "Extra configuration of git";
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
      ".opencommit_provider" = {
        mode = "0660";
        path = "${config.${namespace}.user.homeDir}/.opencommit";
        content = ''
          ${opencommitSharedConfig}
          ${cfg.opencommit.customConfig}
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

      includes = lib.concatLists [
        cfg.includeConfigs
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

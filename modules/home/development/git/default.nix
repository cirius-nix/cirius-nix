{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.cirius) mkStrOption;

  cfg = config.cirius.development.git;
in
{
  options.cirius.development.git = {
    enable = mkEnableOption "Git";
    userName = mkStrOption null "The full name of the user.";
    userEmail = mkStrOption null "The e-mail address of the user.";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ gh ];
    programs.git = {
      inherit (cfg) enable userName userEmail;

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

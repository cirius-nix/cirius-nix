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

  inherit (config.${namespace}) user;
  inherit (config.${namespace}.development) git;
  inherit (config.${namespace}.development.cli-utils) fish;
  inherit (config.${namespace}.development.ide) vscode;

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
    enableFishIntegration = mkEnableOption "Enable fish shell integration";
    opencommit = {
      customConfig = mkStrOption "" "Custom config";
    };
    includeConfigs = mkListOption lib.types.attrs [ ] "Extra configuration of git";
    fishIntegration = {
      enable = mkEnableOption "Enable fish shell integration";
    };
    vscodeIntegration = {
      enable = mkEnableOption "Enable vscode integration";
      extensions = mkListOption lib.types.package (with pkgs.vscode-extensions; [
        waderyan.gitblame
        eamodio.gitlens
      ]) "Extra vscode packages";
    };
  };

  config = mkIf git.enable {
    programs.fish.plugins = mkIf (fish.enable && git.fishIntegration.enable) [
      {
        name = "forgit";
        inherit (pkgs.fishPlugins.forgit) src;
      }
    ];

    ${namespace}.development.cli-utils.fish = mkIf (fish.enable && git.fishIntegration.enable) {
      aliases = {
        "lzgit" = "lazygit";
        "g" = "git";
        "gf" = "git-forgit";
      };
    };

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
          ${git.opencommit.customConfig}
        '';
      };
    };
    programs = {
      lazygit = {
        inherit (git) enable;

        settings.git.paging = {
          pager = if git.pager then "delta --dark --syntax-theme 'Dracula' --paging=never" else "less";
        };
      };
      git = {
        inherit (git) enable;
        userName = user.username;
        userEmail = user.email;
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
          git.includeConfigs
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
      vscode.profiles.default.extensions = mkIf (
        vscode.enable && git.vscodeIntegration.enable
      ) git.vscodeIntegration.extensions;
    };
  };
}

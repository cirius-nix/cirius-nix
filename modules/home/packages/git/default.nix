{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.cirius) mkStrOption;

  cfg = config.cirius.packages.git;
in
{
  options.cirius.packages.git = {
    enable = mkEnableOption "Git";
    userName = mkStrOption null "The full name of the user.";
    userEmail = mkStrOption null "The e-mail address of the user.";
  };

  config = mkIf cfg.enable {
    programs.git = {
      inherit (cfg) enable userName userEmail;

      extraConfig = {
        core.whitespace = "trailing-space,space-before-tab";
        init.defaultBranch = "main";
        pull.rebase = true;
        push.autoSetupRemote = true;
      };
    };
  };
}

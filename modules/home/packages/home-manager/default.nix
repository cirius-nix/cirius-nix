{
  config,
  lib,
  namespace,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.${namespace}) mkStrOption;

  cfg = config.${namespace}.packages.home-manager;
in
{
  options.${namespace}.packages.home-manager = {
    enable = mkEnableOption "home-manager";
    username = mkStrOption null "The name of the user account.";
    homeDirectory = mkStrOption null "The home directory of the user.";
    name = mkStrOption null "The full name of the user.";
    email = mkStrOption null "The e-mail address of the user.";
  };

  config = mkIf cfg.enable {
    programs.home-manager = {
      inherit (cfg) enable;
    };
  };
}

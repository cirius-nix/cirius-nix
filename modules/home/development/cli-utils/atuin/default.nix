{
  config,
  lib,
  namespace,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  inherit (config.${namespace}.development.cli-utils) atuin fish;
in
{
  options.${namespace}.development.cli-utils.atuin = {
    enable = mkEnableOption "Enable Atuin";
  };

  config = mkIf atuin.enable {
    programs = {
      atuin = {
        enable = true;
        daemon.enable = true;
        enableFishIntegration = fish.enable;
        settings = {
          auto_sync = true;
          sync_frequency = "5m";
          style = "compact"; # compact | full | auto
          filter_mode = "workspace";
          filter_mode_shell_up_key_binding = "workspace";
          workspaces = true;
          secret_filter = true;
        };
      };
    };
  };
}

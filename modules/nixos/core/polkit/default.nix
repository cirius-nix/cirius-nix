{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.core.polkit;
in
{
  options.${namespace}.core.polkit = {
    enable = mkBoolOpt false "Enable polkit.";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ kdePackages.polkit-kde-agent-1 ];

    security.polkit = {
      enable = true;
      debug = lib.mkDefault true;

      extraConfig = lib.mkIf config.security.polkit.debug ''
        /* Log authorization checks. */
        polkit.addRule(function(action, subject) {
          polkit.log("user " +  subject.user + " is attempting action " + action.id + " from PID " + subject.pid);
        });
      '';
    };

    systemd = {
      user.services.polkit-kde-authentication-agent-1 = {
        after = [ "graphical-session.target" ];
        description = "polkit-kde-authentication-agent-1";
        wantedBy = [ "graphical-session.target" ];
        wants = [ "graphical-session.target" ];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
      };
    };
  };
}

{
  config,
  lib,
  namespace,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.${namespace}.packages.email.thunderbird;
in
{
  options.${namespace}.packages.email.thunderbird = {
    enable = mkEnableOption "thunderbird";
    main = lib.${namespace}.mkEnumOption [
      "thunderbird"
      "mailspring"
    ] "thunderbird" "Main Email Client";
  };

  config = mkIf cfg.enable {
    ${namespace}.desktop-environment.hyprland = {
      variables = {
        mainEmail = cfg.main;
      };
      events.onEmptyWorkspaces = {
        "6" = [ "$mainEmail" ];
      };
      rules.winv2 = {
        workspace = {
          "6 silent" = [
            "class:^(thunderbird)$"
            "class:^(Mailspring)$"
          ];
        };
        float = {
          "" = [ "class:^(thunderbird)$,title:.*(Reminders)$" ];
        };
        size = {
          "1100 600" = [ "class:^(thunderbird)$,title:.*(Reminders)$" ];
        };
        move = {
          "78% 6%" = [ "class:^(thunderbird)$,title:.*(Reminders)$" ];
        };
        pin = {
          "" = [ "class:^(thunderbird)$,title:.*(Reminders)$" ];
        };
      };
    };
    home.packages = [
      pkgs.${cfg.main}
    ];
  };
}

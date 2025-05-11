{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.${namespace}) mkStrOption;
  cfg = config.${namespace}.development.term;
in
{
  options.${namespace}.development.term = {
    enable = mkEnableOption "term";
    main = lib.${namespace}.mkEnumOption [
      "kitty"
      "weztem"
    ] "kitty" "Main terminal for internal used";
    theme = mkStrOption "GitHub_Dark_Dimmed" "Theme";
  };

  config = mkIf cfg.enable {
    ${namespace} = lib.optionalAttrs pkgs.stdenv.isLinux {
      desktop-environment.hyprland = {
        events.onEmptyWorkspaces = {
          "1" = [ "$term" ];
        };
        variables = {
          term = lib.getExe pkgs.kitty;
        };
        shortcuts = [
          "$mainMod, RETURN, exec, $term"
        ];
      };
    };
  };
}

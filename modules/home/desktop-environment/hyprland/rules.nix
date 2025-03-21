{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkIf;
  deCfg = config.${namespace}.desktop-environment;
in
{
  config = mkIf (deCfg.kind == "hyprland") {
    wayland.windowManager.hyprland = {
      settings = {
        layerrule = [
          "blur,waybar"
        ];
        windowrulev2 = [
          "float, class:viewnior"
          "float, class:feh"
          "float, class:wlogout"
          "float, class:file_progress"
          "float, class:confirm"
          "float, class:dialog"
          "float, class:download"
          "float, class:notification"
          "float, class:error"
          "float, class:splash"
          "float, class:confirmreset"
          "float, class:org.kde.polkit-kde-authentication-agent-1"
          "float, class:^(wdisplays)$"
          "size 1100 600, class:^(wdisplays)$"
          "float, class:^(blueman-manager)$"
          "float, class:^(nm-connection-editor)$"
          "float, class:it.mijorus.smile"

          # floating terminal
          "float, title:^(floatterm)$"
          "size 1100 600, title:^(floatterm)$"
          "move center, title:^(floatterm)$"
          "animation slide, title:^(floatterm)$"

          # thunar file operation progress
          "float, class:^(thunar)$,title:^(File Operation Progress)$"
          "size 800 600, class:^(thunar)$,title:^(File Operation Progress)$"
          "move 78% 6%, class:^(thunar)$,title:^(File Operation Progress)$"
          "pin, class:^(thunar)$,title:^(File Operation Progress)$"

          "float, title:^(Picture-in-Picture)$"
          "pin, title:^(Picture-in-Picture)$"

          # fix xwayland apps
          "rounding 0, xwayland:1, floating:1"
          "dimaround, class:^(gcr-prompter)$"

          # Require input
          "bordercolor rgba(ed8796FF), class:org.kde.polkit-kde-authentication-agent-1"
          "dimaround, class:org.kde.polkit-kde-authentication-agent-1"
          "stayfocused, class:org.kde.polkit-kde-authentication-agent-1"
          "nofocus, class:^(steam)$, title:^()$"
          "stayfocused, class:it.mijorus.smile"
        ];
      };
    };
  };
}

{
  config,
  lib,
  pkgs,
  namespace,
  osConfig,
  ...
}:
let
  inherit (lib) mkIf getExe getExe';
  # FIXME: do not hardcode here
  user = lib.cirius.findOrNull osConfig.cirius.users.users "username" "cirius";
  convert = getExe' pkgs.imagemagick "convert";
  grimblast = getExe pkgs.grimblast;
  wl-copy = getExe' pkgs.wl-clipboard "wl-copy";
  wl-paste = getExe' pkgs.wl-clipboard "wl-paste";
  getDateTime = getExe (pkgs.writeShellScriptBin "getDateTime" ''echo $(date +'%Y%m%d_%H%M%S')'');
  screenshot-path = "/home/${user.username}/Pictures/screenshots";
  deCfg = config.${namespace}.desktop-environment;
in
{
  config = mkIf (deCfg.kind == "hyprland") {
    wayland.windowManager.hyprland = {
      # NOTE: different bind flags
      # l -> locked, will also work when an input inhibitor (e.g. a lockscreen) is active.
      # r -> release, will trigger on release of a key.
      # e -> repeat, will repeat when held.
      # n -> non-consuming, key/mouse events will be passed to the active window in addition to triggering the dispatcher.
      # m -> mouse, Mouse binds are binds that rely on mouse movement. They will have one less arg
      # t -> transparent, cannot be shadowed by other binds.
      # i -> ignore mods, will ignore modifiers.
      settings = {
        # default applications
        # "$term" = "${getExe pkgs.kitty}";
        # "$browser" = "${getExe pkgs.floorp}";
        # "$editor" = "${getExe pkgs.neovim}";
        "$music" = "${getExe pkgs.youtube-music}";
        "$notification_center" = "${getExe' config.services.swaync.package "swaync-client"}";
        "$launcher" = "anyrun";
        # "$launcher_alt" = "${getExe config.programs.rofi.package} -show drun -n";
        # "$launcher_shift" = "${getExe config.programs.rofi.package} -show run -n";
        "$launchpad" = "${getExe pkgs.rofi} -show drun -n";
        "$screen-locker" = "${getExe pkgs.swaylock}";
        # "$window-inspector" = "${getExe hyprland-contrib.packages.${system}.hyprprop}";
        # screenshot commands
        "$notify-screenshot" = ''${getExe pkgs.libnotify} --icon "$file" "Screenshot Saved"'';
        "$screenshot-path" = "/home/${user.username}/Pictures/screenshots";
        "$grimblast_area_file" =
          ''file="${screenshot-path}/$(${getDateTime}).png" && ${grimblast} --freeze --notify save area "$file"'';
        "$grimblast_active_file" =
          ''file="${screenshot-path}/$(${getDateTime}).png" && ${grimblast} --notify save active "$file"'';
        "$grimblast_screen_file" =
          ''file="${screenshot-path}/$(${getDateTime}).png" && ${grimblast} --notify save screen "$file"'';
        "$grimblast_area_swappy" = ''${grimblast} --freeze save area - | ${getExe pkgs.swappy} -f -'';
        "$grimblast_active_swappy" = ''${grimblast} save active - | ${getExe pkgs.swappy} -f -'';
        "$grimblast_screen_swappy" = ''${grimblast} save screen - | ${getExe pkgs.swappy} -f -'';
        "$grimblast_area_clipboard" = "${grimblast} --freeze --notify copy area";
        "$grimblast_active_clipboard" = "${grimblast} --notify copy active";
        "$grimblast_screen_clipboard" = "${grimblast} --notify copy screen";

        # utility commands
        "$color_picker" =
          "${getExe pkgs.hyprpicker} -a && (${convert} -size 32x32 xc:$(${wl-paste}) /tmp/color.png && ${getExe pkgs.libnotify} \"Color Code:\" \"$(${wl-paste})\" -h \"string:bgcolor:$(${wl-paste})\" --icon /tmp/color.png -u critical -t 4000)";
        "$cliphist" =
          "${getExe pkgs.cliphist} list | anyrun --show-results-immediately true | ${getExe pkgs.cliphist} decode | ${wl-copy}";
        bind =
          [
            # launcher
            "$mainMod_SHIFT, SPACE, exec, run-as-service $($launcher)"
            "$mainMod, SPACE, exec, run-as-service $($launchpad)"

            # apps
            "$mainMod_SHIFT, P, exec, $color_picker"
            "$mainMod, DELETE, exec, $screen-locker --immediate"
            "$mainMod, N, exec, $notification_center -t -sw"
            "$mainMod, ', exec, $cliphist"
            "$mainMod, I, exec, ${getExe pkgs.libnotify} \"$($window-inspector)\""
            "$mainMod, PERIOD, exec, ${getExe pkgs.smile}"

            # kill window
            "$mainMod, Q, killactive,"

            # screenshots
            # File
            ", Print, exec, $grimblast_active_file"
            "SHIFT, Print, exec, $grimblast_area_file"
            # "SHIFT_CTRL, S, exec, $grimblast_area_file"
            "$mainMod, Print, exec, $grimblast_screen_file"

            # Area / Window
            "ALT, Print, exec, $grimblast_active_swappy"
            "ALT_CTRL, Print, exec, $grimblast_area_swappy"
            "ALT_SUPER, Print, exec, $grimblast_screen_swappy"
            # "SUPER_CTRL_SHIFT, S, exec, $grimblast_screen_swappy"

            # Clipboard
            "CTRL, Print, exec, $grimblast_active_clipboard"
            "CTRL_SHIFT, Print, exec, $grimblast_area_clipboard"
            "SUPER_CTRL, Print, exec, $grimblast_screen_clipboard"

            "SUPER_SHIFT, S, exec, $grimblast_area_clipboard"

            # Screen recording
            "SUPER_CTRLALT, Print, exec, $screen-recorder screen"
            "SUPER_CTRLALTSHIFT, Print, exec, $screen-recorder area"

            "SUPER_ALT, V, togglefloating,"
            "$mainMod, P, pseudo, # dwindle"
            "$mainMod, J, togglesplit, # dwindle"
            "$mainMod, F, fullscreen"

            ### Windows
            # focus windows
            "$mainMod,h,movefocus,l"
            "$mainMod,l,movefocus,r"
            "$mainMod,k,movefocus,u"
            "$mainMod,j,movefocus,d"
            # Move window
            "$mainMod_ALT,h,movewindow,l"
            "$mainMod_ALT,l,movewindow,r"
            "$mainMod_ALT,k,movewindow,u"
            "$mainMod_ALT,j,movewindow,d"

            "CTRL_SHIFT,h,resizeactive,-10% 0"
            "CTRL_SHIFT,l,resizeactive,10% 0"
            "CTRL_SHIFT,j,resizeactive,0 -10%"
            "CTRL_SHIFT,k,resizeactive,0 10%"

            ### workspaces
            "$mainMod, right, workspace, +1"
            "$mainMod, left, workspace, -1"
            "$mainMod, mouse_down, workspace, e+1"
            "$mainMod, mouse_up, workspace, e-1"

            # Move to workspace left/right
            "$mainMod_SHIFT, right, movetoworkspace, +1"
            "$mainMod_SHIFT, l, movetoworkspace, +1"
            "$mainMod_SHIFT, left, movetoworkspace, -1"
            "$mainMod_SHIFT, h, movetoworkspace, -1"

            # Scratchpad
            "SUPER_SHIFT,grave,movetoworkspace,special:scratchpad"
            "SUPER,grave,togglespecialworkspace,scratchpad"

            # Inactive
            "ALT_SHIFT,grave,movetoworkspace,special:inactive"
            "ALT,grave,togglespecialworkspace,inactive"
            # simple movement between monitors
            "SUPER_ALT, up, focusmonitor, u"
            "SUPER_ALT, k, focusmonitor, u"
            "SUPER_ALT, down, focusmonitor, d"
            "SUPER_ALT, j, focusmonitor, d"
            "SUPER_ALT, left, focusmonitor, l"
            "SUPER_ALT, h, focusmonitor, l"
            "SUPER_ALT, right, focusmonitor, r"
            "SUPER_ALT, l, focusmonitor, r"

            # moving current workspace to monitor
            # "$hyper,down,movecurrentworkspacetomonitor,d"
            # "$hyper,j,movecurrentworkspacetomonitor,d"
            # "$hyper,up,movecurrentworkspacetomonitor,u"
            # "$hyper,k,movecurrentworkspacetomonitor,u"
            # "$hyper,left,movecurrentworkspacetomonitor,l"
            # "$hyper,h,movecurrentworkspacetomonitor,l"
            # "$hyper,right,movecurrentworkspacetomonitor,r"
            # "$hyper,l,movecurrentworkspacetomonitor,r"
          ]
          # Switch workspaces with CTRL_ALT + [0-9]
          ++ (builtins.concatLists (
            builtins.genList (
              x:
              let
                ws =
                  let
                    c = (x + 1) / 10;
                  in
                  builtins.toString (x + 1 - (c * 10));
              in
              [
                "$SUPER, ${ws}, workspace, ${toString (x + 1)}"
                "$SUPER_SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
              ]
            ) 10
          ));
        bindl = [
          # Kill and restart crashed hyprlock
          "$mainMod, BackSpace, exec, pkill -SIGUSR1 hyprlock || WAYLAND_DISPLAY=wayland-1 $screen-locker --immediate"
          "$mainMod, DEL, exec, systemctl --user exit"
          "$lHyper, L, exit,"
          "$rHyper, R, exec, reboot"
          "$rHyper, P, exec, shutdown"

          ",XF86AudioRaiseVolume,exec,wpctl set-volume @DEFAULT_AUDIO_SINK@ 2.5%+"
          ",XF86AudioLowerVolume,exec,wpctl set-volume @DEFAULT_AUDIO_SINK@ 2.5%-"
          ",XF86AudioMute,exec,wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
          ",XF86MonBrightnessUp,exec,light -A 5"
          ",XF86MonBrightnessDown,exec,light -U 5"
          ",XF86AudioMedia,exec,${getExe pkgs.playerctl} play-pause"
          ",XF86AudioPlay,exec,${getExe pkgs.playerctl} play-pause"
          ",XF86AudioStop,exec,${getExe pkgs.playerctl} stop"
          ",XF86AudioPrev,exec,${getExe pkgs.playerctl} previous"
          ",XF86AudioNext,exec,${getExe pkgs.playerctl} next"
        ];
        bindm = [
          # Move/resize windows with mainMod + LMB/RMB and dragging
          "$mainMod, mouse:272, movewindow #left click"
          "CTRL_SHIFT, mouse:272, movewindow #left click"
          "$mainMod, mouse:273, resizewindow #right click"
          "CTRL_SHIFT, mouse:273, resizewindow #right click"
        ];
      };
    };
  };
}

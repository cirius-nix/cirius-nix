{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib)
    mkIf
    getExe
    types
    ;

  inherit (lib.${namespace}) mkOpt;
  deCfg = config.${namespace}.desktop-environment;
  cfg = deCfg.hyprland;
in
{
  imports = lib.snowfall.fs.get-non-default-nix-files ./.;
  options.cirius.desktop-environment.hyprland = {
    theme = mkOpt types.str "gruvbox" "The theme to use";
    appendConfig = lib.mkOption {
      type = lib.types.lines;
      default = "";
    };
    prependConfig = lib.mkOption {
      type = lib.types.lines;
      default = "";
    };
  };
  config = mkIf (deCfg.kind == "hyprland") {
    wayland.windowManager.hyprland =
      let
        systemctl = lib.getExe' pkgs.systemd "systemctl";
      in
      {
        enable = true;
        extraConfig = ''
          ### EXTRA CONFIG ###
          monitor = , preferred, auto, 1.5
          ${cfg.prependConfig}
          ${cfg.appendConfig}
        '';
        systemd = {
          enable = true;
          enableXdgAutostart = true;
          extraCommands = [
            "${systemctl} --user stop hyprland-session.target"
            "${systemctl} --user reset-failed"
            "${systemctl} --user start hyprland-session.target"
          ];
          variables = [
            "--all"
          ];
        };
        xwayland.enable = true;
        settings = {
          exec = [ "${getExe pkgs.libnotify} --icon ~/.face -u normal \"Hello $(whoami)\"" ];
          monitor = ",preferred,auto,1.5";
        };
      };
    home =
      let
        inherit (cfg.themes) activatedTheme;
      in
      {
        packages = with pkgs; [
          xwaylandvideobridge
          grim
          slurp
          libgcc
        ];
        pointerCursor =
          {
            x11.enable = true;
          }
          // mkIf (activatedTheme != null) {
            inherit (activatedTheme.cursor) name package size;
          };
        sessionVariables =
          {
            CLUTTER_BACKEND = "wayland";
            GDK_BACKEND = "wayland,x11";
            MOZ_ENABLE_WAYLAND = "1";
            MOZ_USE_XINPUT2 = "1";
            WLR_DRM_NO_ATOMIC = "1";
            XDG_SESSION_TYPE = "wayland";
            _JAVA_AWT_WM_NONREPARENTING = "1";
            __GL_GSYNC_ALLOWED = "0";
            __GL_VRR_ALLOWED = "0";
          }
          ### Use xcursor for qt5,6ct and gtk3,4
          // mkIf (activatedTheme != null) {
            CURSOR_THEME = activatedTheme.cursor.name;
            XCURSOR_SIZE = activatedTheme.cursor.size;
            XCURSOR_THEME = activatedTheme.cursor.name;
          };
      };
  };
}

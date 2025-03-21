{
  config,
  lib,
  pkgs,
  osConfig,
  namespace,
  ...
}:
lib.optionalAttrs pkgs.stdenv.isLinux (
  let
    deCfg = config.${namespace}.desktop-environment;
    hyprCfg = deCfg.hyprland;
    cfg = hyprCfg.themes.gtk;
    inherit (lib) mkIf;
    inherit (lib.${namespace}) boolToNum mkBoolOpt nested-default-attrs;
    inherit (hyprCfg.themes) activatedTheme;

    enabled = pkgs.stdenv.isLinux && deCfg.kind == "hyprland" && cfg.enable;
  in
  {
    options.${namespace}.desktop-environment.hyprland.themes.gtk = {
      enable = mkBoolOpt false "Whether to customize GTK and apply themes.";
      usePortal = mkBoolOpt false "Whether to use the GTK Portal.";
    };

    config = mkIf enabled {
      home = {
        packages = with pkgs; [
          dconf
          glib # gsettings
          gtk3.out # for gtk-launch
          libappindicator-gtk3
          gnome-tweaks
        ];
        sessionVariables = {
          GTK_USE_PORTAL = "${toString (boolToNum cfg.usePortal)}";
        };
      };
      dconf = {
        enable = true;
        settings = nested-default-attrs {
          "org/gnome/shell" = {
            disable-user-extensions = false;
            enabled-extensions = [ "user-theme@gnome-shell-extensions.gcampax.github.com" ];
          };
          "org/gnome/shell/extensions/user-theme" = {
            inherit (activatedTheme.gtk-theme) name;
          };
          "org/gnome/desktop/interface" = {
            color-scheme = "prefer-dark";
            cursor-size = activatedTheme.cursor.size;
            cursor-theme = activatedTheme.cursor.name;
            enable-hot-corners = false;
            font-name = osConfig.${namespace}.fonts.default;
            gtk-theme = activatedTheme.gtk-theme.name;
            icon-theme = activatedTheme.icon.name;
          };
        };
      };
      gtk = {
        enable = true;
        font = {
          name = osConfig.${namespace}.fonts.default;
          size = 13;
        };
        gtk2 = {
          configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
          extraConfig = ''
            gtk-xft-antialias=1
            gtk-xft-hinting=1
            gtk-xft-hintstyle="hintslight"
            gtk-xft-rgba="rgb"
          '';
        };
        gtk3.extraConfig = {
          gtk-application-prefer-dark-theme = true;
          gtk-button-images = 1;
          gtk-decoration-layout = "appmenu:none";
          gtk-enable-event-sounds = 0;
          gtk-enable-input-feedback-sounds = 0;
          gtk-error-bell = 0;
          gtk-menu-images = 1;
          gtk-toolbar-icon-size = "GTK_ICON_SIZE_LARGE_TOOLBAR";
          gtk-toolbar-style = "GTK_TOOLBAR_BOTH";
          gtk-xft-antialias = 1;
          gtk-xft-hinting = 1;
          gtk-xft-hintstyle = "hintslight";
        };
        gtk4.extraConfig = {
          gtk-application-prefer-dark-theme = true;
          gtk-decoration-layout = "appmenu:none";
          gtk-enable-event-sounds = 0;
          gtk-enable-input-feedback-sounds = 0;
          gtk-error-bell = 0;
          gtk-xft-antialias = 1;
          gtk-xft-hinting = 1;
          gtk-xft-hintstyle = "hintslight";
        };
        iconTheme = {
          inherit (activatedTheme.icon) name package;
        };
        theme = {
          inherit (activatedTheme.gtk-theme) name package;
        };
      };

      xdg = {
        configFile =
          let
            gtk4Dir = "${activatedTheme.gtk-theme.package}/share/themes/${activatedTheme.gtk-theme.name}/gtk-4.0";
          in
          {
            "gtk-4.0/assets".source = "${gtk4Dir}/assets";
            "gtk-4.0/gtk.css".source = "${gtk4Dir}/gtk.css";
            "gtk-4.0/gtk-dark.css".source = "${gtk4Dir}/gtk-dark.css";
          };
        systemDirs.data =
          let
            schema = pkgs.gsettings-desktop-schemas;
          in
          [ "${schema}/share/gsettings-schemas/${schema.name}" ];
      };
    };
  }
)

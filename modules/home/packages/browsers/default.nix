{
  config,
  pkgs,
  lib,
  namespace,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.${namespace}.packages.browsers;
in
{
  options.${namespace}.packages.browsers = {
    enable = mkEnableOption "browsers";
  };

  config = mkIf (cfg.enable && !pkgs.stdenv.isDarwin) {
    ${namespace} = lib.optionalAttrs pkgs.stdenv.isLinux {
      desktop-environment.hyprland = {
        variables = {
          browser = lib.getExe pkgs.floorp;
        };
        shortcuts = [
          "$mainMod, B, exec, $browser"
        ];
        rules = {
          winv2 = {
            idleinhibit = {
              "fullscreen" = [ ];
              "focus" = [
                "idleinhibit focus, class:^(mpv|.+exe)$"
              ];
            };
          };
        };
      };
    };

    home = {
      packages = with pkgs; [
        firefox
        floorp
        google-chrome
        chromium
      ];
    };
  };
}

{
  config,
  pkgs,
  lib,
  namespace,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.${namespace}.packages.media;
in
{
  options.${namespace}.packages.media = {
    enable = mkEnableOption "media";
  };

  config = mkIf cfg.enable {
    ${namespace} = lib.optionalAttrs pkgs.stdenv.isLinux {
      desktop-environment.hyprland = {
        events.onEmptyWorkspaces = {
          "7" = [ "spotify" ];
        };
        rules.winv2 = {
          tile = {
            "" = [
              "class:^(Spotify|Spotify Free)$"
              "title:^(Spotify|Spotify Free)$"
            ];
          };
          workspace = {
            "7" = [
              "class:^(mpv|vlc|mpdevil)$"
            ];
            "7 silent" = [
              "class:^(Spotify|Spotify Free)$"
              "title:^(Spotify|Spotify Free)$"
            ];
          };
        };
      };
    };
    home = {
      packages = with pkgs; [
        vlc
        spotify
        spotify-player
      ];
    };
  };
}

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
    home = {
      packages = with pkgs; [
        vlc
      ];
    };
  };
}

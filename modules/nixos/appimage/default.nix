{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.cirius.appimage;
in
{
  options.cirius.appimage = {
    enable = mkEnableOption "appimage";
  };

  config = mkIf cfg.enable {
    programs.appimage = {
      enable = true;
      binfmt = true;
      package = pkgs.appimage-run.override {
        extraPkgs = pkgs: [
          pkgs.ffmpeg
          pkgs.imagemagick
        ];
      };
    };
  };
}

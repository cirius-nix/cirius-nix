{
  config,
  lib,
  namespace,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.system.xdg;

in
# TODO: define XDG MIME types
# associations = {
# };
{
  options.${namespace}.system.xdg = {
    enable = mkEnableOption "xdg";
  };

  config = mkIf cfg.enable {
    xdg = {
      enable = true;
      cacheHome = config.home.homeDirectory + "/.local/cache";

      # TODO: use mime apps.
      # mimeApps = lib.mkIf pkgs.stdenv.isLinux {
      #   enable = true;
      #   defaultApplications = associations;
      #   associations.added = associations;
      # };

      userDirs = lib.mkIf pkgs.stdenv.isLinux {
        enable = true;
        createDirectories = true;
        extraConfig = {
          XDG_SCREENSHOTS_DIR = "${config.xdg.userDirs.pictures}/screenshots";
        };
      };
    };
  };
}

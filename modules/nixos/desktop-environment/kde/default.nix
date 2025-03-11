{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:

let
  inherit (lib) mkIf;
  deCfg = config.${namespace}.desktop-environment;
in
{
  config = mkIf (deCfg.kind == "kde") {
    environment.systemPackages = with pkgs; [
      kdePackages.kconfig
      kdePackages.filelight
      wayland-utils
      egl-wayland
    ];

    services = {
      displayManager.sddm.enable = true;
      desktopManager.plasma6.enable = true;
      xserver = {
        enable = true;
        xkb = {
          layout = "us";
          variant = "";
        };
      };
      printing.enable = false;
    };
  };
}

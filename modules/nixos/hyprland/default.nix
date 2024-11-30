{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.cirius.hyprland;
in
{
  options.cirius.hyprland = {
    enable = mkEnableOption "Hyprland";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      kdePackages.qtstyleplugin-kvantum
      kdePackages.libksysguard
      kdePackages.ksystemlog
      wayland-utils
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
    };
  };
}

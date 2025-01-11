{ pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  cirius = {
    # define the user
    users = {
      enable = true;
      users = [
        {
          username = "cirius";
          name = "Cirius";
          email = "hieu.tran21198@gmail.com";
          shell = "fish";
        }
      ];
    };

    # enable modules defined in: pkg_root/modules/nixos
    home-manager.enable = true;
    locale.enable = true;
    network.enable = true;
    nix.enable = true;
    security.enable = true;
    ssh.enable = true;
    pirewire.enable = true;
    kde.enable = true;
    virtualisation.enable = true;
    clipboard.enable = true;
    input-method.enable = true;
    bluetooth.enable = true;
    appimage.enable = true;
    nvidia.enable = true;
    zen.enable = true;
    term.enable = true;
  };

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
    flatpak.enable = true;

    printing.enable = false;
  };

  environment.systemPackages = with pkgs; [
    kdePackages.qtstyleplugin-kvantum
    kdePackages.libksysguard
    kdePackages.ksystemlog
    wayland-utils
  ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  nixpkgs.config.allowUnfree = true;

  # state version
  system.stateVersion = "24.05";
}

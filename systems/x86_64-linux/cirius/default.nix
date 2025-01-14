{ pkgs, namespace, ... }:
let
  user = {
    username = "cirius";
    name = "Cirius";
    email = "hieu.tran21198@gmail.com";
    shell = "fish";
  };
in
{
  imports = [ ./hardware-configuration.nix ];

  ${namespace} = {
    users = {
      enable = true;
      users = [
        user
      ];
    };
    motherboard = {
      enable = true;
    };
    core = {
      nix = {
        enable = true;
        nixLd = {
          enable = true;
        };
      };
      clipboard.enable = true;
      input-method.enable = true;
      bluetooth.enable = true;
      keyring.enable = true; # TODO: move keyring to desktop-environment settings.
      locale.enable = true;
      network = {
        enable = true;
        hostname = "cirius";
        enableWarp = true;
      };
      audio.enable = true;
      security.enable = true;
      ssh.enable = true;
      power-profile.enable = true;
      virtualisation = {
        enable = true;
        waydroid = {
          enable = false;
          autoStart = true;
        };
      };
    };
    applications = {
      home-manager.enable = true;
      browsers.enable = true;
      appimage.enable = true;
      looking-glass.enable = true;
      looking-glass.user = user.username;
    };
    cpu-utils.amd = {
      enable = true;
      extraUdevRules = {
        "DeepCool-AG400" =
          ''SUBSYSTEM=="hidraw", ATTRS{idVendor}=="3633", ATTRS{idProduct}=="0008", MODE="0666"'';
      };
    };
    gpu-drivers = {
      nvidia.enable = true;
    };

    desktop-environment = {
      kind = "kde";
    };
    fonts.enable = true;
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
    printing.enable = false;
  };

  systemd.services.deepcool-digital = {
    description = "DeepCool Digital";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];

    serviceConfig = {
      ExecStart = ''${builtins.toString ./assets/deepcool-digital-linux} -m auto'';
      Restart = "always";
      User = "root";
      Group = "root";
    };
  };

  environment.systemPackages = with pkgs; [
    wayland-utils
    kdePackages.filelight
  ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  nixpkgs.config.allowUnfree = true;

  # state version
  system.stateVersion = "24.05";
}

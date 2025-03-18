{
  namespace,
  ...
}:
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
      benchmark.enable = true;
      home-manager.enable = true;
      browsers.enable = true;
      office.enable = true;
      appimage.enable = true;
      looking-glass = {
        enable = true;
        user = user.username;
      };
      cli-utils.enable = true;
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
      # systemctl --user unmask pipewire-pulse
      # systemctl --user unmask pipewire-pulse.socket
      # systemctl --user --now enable pipewire pipewire-pulse
      kind = "hyprland";
    };
    fonts.enable = true;
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

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  nixpkgs.config.allowUnfree = true;

  # state version
  system.stateVersion = "24.05";
}

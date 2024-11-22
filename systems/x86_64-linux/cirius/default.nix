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
  };

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  services = {
    printing.enable = false;
  };

  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
    # of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.graphics = {
    enable = true;
  };

  nixpkgs.config.allowUnfree = true;

  # state version
  system.stateVersion = "24.05";
}

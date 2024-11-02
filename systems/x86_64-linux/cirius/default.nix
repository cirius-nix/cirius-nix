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
    # virtualisation.enable = true;
    clipboard.enable = true;
    input-method.enable = true;
  };

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  services = {
    printing.enable = false;
  };

  # state version
  system.stateVersion = "24.05";
}

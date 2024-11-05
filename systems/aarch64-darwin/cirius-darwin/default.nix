{lib,...}: {
  cirius = {
    # define the user
    users = {
      enable = true;
      users = [
        {
          username = "cirius-darwin";
          name = "Cirius Darwin";
          email = "hieu@buuuk.com";
          shell = "fish";
        }
      ];
    };

    # enable modules defined in: pkg_root/modules/darwin
    home-manager.enable = true;
    nix.enable = true;
    virtualisation.enable = true;
  };

  nix.settings.experimental-features = "nix-command flakes";

  services.nix-daemon.enable = true;
  system.stateVersion = 5;
}

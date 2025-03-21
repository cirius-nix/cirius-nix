{ namespace, ... }:
{
  ${namespace} = {
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
    core.virtualisation.enable = true;
  };

  nix.settings.experimental-features = "nix-command flakes";

  # nix-darwin now manages nix-daemon unconditionally when
  # `nix.enable` is on.
  nix.enable = true;
  system.stateVersion = 5;
}

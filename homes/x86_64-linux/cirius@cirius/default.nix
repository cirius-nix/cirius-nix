{ lib, osConfig, ... }:
let
  user = lib.cirius.findOrNull osConfig.cirius.users.users "username" "cirius";
in
{
  cirius.development = {
    git = {
      enable = true;
      userName = user.name;
      userEmail = user.email;
    };
    delta.enable = true;
    lazygit.enable = true;
    db.enable = true;
    cli-utils.enable = true;
    go.enable = true;
    fish = {
      enable = true;
      customPaths = [ "~/Applications" ];
    };
  };

  cirius.packages = {
    home-manager = {
      enable = true;
      inherit (user) username;
      inherit (user) name;
      inherit (user) email;
    };
  };
}

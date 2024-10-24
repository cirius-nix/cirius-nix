{ lib, osConfig, ... }:
let
  user = lib.cirius.findOrNull osConfig.cirius.users.users "username" "cirius";
in
{
  cirius.packages = {
    git = {
      enable = true;
      userName = user.name;
      userEmail = user.email;
    };

    home-manager = {
      enable = true;
      inherit (user) username;
      inherit (user) name;
      inherit (user) email;
    };
  };
}

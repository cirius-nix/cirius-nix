{
  lib,
  osConfig,
  pkgs,
  ...
}:
let
  user = lib.cirius.findOrNull osConfig.cirius.users.users "username" "cirius-darwin";
in
{
  cirius.development = {
    git = {
      enable = true;
      userName = user.name;
      userEmail = user.email;
    };
    helix.enable = true;
    delta.enable = true;
    lazygit.enable = true;
    db.enable = true;
    cli-utils.enable = true;
    go.enable = true;
    java.enable = true;
    starship.enable = true;
    api-client.enable = true;
    node.enable = true;
    zed.enable = true;
    fish = {
      enable = true;
      customPaths = [ "~/Applications" ];
      aliases = {
        "rbnix" = "darwin-rebuild switch --flake .#cirius-darwin";
        "tf" = "${pkgs.terraform}/bin/terraform";
        "gco" = "${pkgs.git}/bin/git checkout";
        "gpl" = "${pkgs.git}/bin/git pull origin";
        "gps" = "${pkgs.git}/bin/git push origin";
        "gm" = "${pkgs.git}/bin/git merge";
      };
    };
    aws = {
      enable = true;
    };
    nixvim.enable = true;
    vscode.enable = true;
    postman.enable = true;
  };

  cirius.packages = {
    home-manager = {
      enable = true;
      inherit (user) username;
      inherit (user) name;
      inherit (user) email;
    };
    # browsers.enable = true;
    # secrets.enable = true;
    fonts.enable = true;
  };
}

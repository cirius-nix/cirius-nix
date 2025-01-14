{
  lib,
  osConfig,
  pkgs,
  ...
}:
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
    kdev.enable = true;
    delta.enable = true;
    lazygit.enable = true;
    db.enable = true;
    cli-utils.enable = true;
    go.enable = true;
    starship.enable = true;
    jetbrains = {
      enable = true;
      noncommercial = true;
    };
    fish = {
      enable = true;
      customPaths = [ "~/Applications" ];
      aliases = {
        "rbnix" = "sudo nixos-rebuild switch --show-trace";
        "nixos-generations" = "nixos-rebuild list-generations";
        "clean-nixos" = "sudo nix-env --delete-generations +5; sudo nix-collect-garbage -d";
        "tf" = "${pkgs.terraform}/bin/terraform";
      };
    };
    aws = {
      enable = true;
    };
    nixvim.enable = true;
    vscode.enable = true;
    postman.enable = true;
    term.enable = true;
  };

  cirius.desktop-environment = {
    hyprland = {
      enable = true;
    };
  };

  cirius.packages = {
    home-manager = {
      enable = true;
      inherit (user) username;
      inherit (user) name;
      inherit (user) email;
    };
    office.enable = true;
    browsers.enable = true;
    secrets.enable = true;
    fonts.enable = true;
    chat.enable = true;
  };
}

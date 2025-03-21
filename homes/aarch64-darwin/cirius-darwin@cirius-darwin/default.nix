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
      pager = true;
    };
    api-client.enable = true;
    langs = {
      go.enable = true;
      java.enable = true;
      node.enable = true;
      nix.enable = true;
    };
    cli-utils = {
      enable = true;
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
    };
    infra = {
      enable = true;
    };
    ide = {
      db = {
        enable = true;
      };
      nixvim = {
        enable = true;
        plugins = {
          ai = {
            enable = true;
            ollamaModel = "qwen2.5-coder:latest"; # deepseek-coder:6.7b | starcoder2:3b | qwen2.5-coder:latest
            ollamaHost = "127.0.0.1:11434";
          };
          debugging.enable = true;
          formatter = {
            enable = true;
          };
        };
      };
      helix = {
        enable = true;
      };
    };
    term.enable = true;
  };

  cirius.packages = {
    home-manager = {
      enable = true;
      inherit (user) username;
      inherit (user) name;
      inherit (user) email;
    };
    fonts.enable = true;
  };
}

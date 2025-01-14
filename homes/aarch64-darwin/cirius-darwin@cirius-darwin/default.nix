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
          ai.enable = true;
          debugging.enable = true;
          formatter = {
            enable = true;
          };
          languages = {
            nix.enable = true;
            typescript = {
              enable = true;
              formatTimeout = 1000;
              enableAngularls = true;
            };
            go = {
              enable = true;
              use3rdPlugins = {
                rayxgo = {
                  enable = true;
                  # >   - go.reftool
                  # >   - go.launch
                  # >   - go.runner
                  # >   - go.alt_getopt
                  # >   - go
                  #    - go.gotest
                  #    - go.null_ls
                  #    - go.inlay
                  #    - go.project
                  #    - go.comment
                  #    - go.tags
                  #    - go.ginkgo
                  #    - go.gotests
                  #    - go.ts.go
                  #    - go.ts.utils
                  #    - go.ts.nodes
                  #    - go.snips
                  #    - go.format
                  #    - go.fixplurals
                  #    - snips.all
                  #    - snips.go
                  config = ''
                    require('go').setup({});
                  '';
                };
              };
            };
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

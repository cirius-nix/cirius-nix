{
  lib,
  osConfig,
  pkgs,
  ...
}:
let
  user = lib.cirius.findOrNull osConfig.cirius.users.users "username" "cirius";
  # m1 = "HDMI-A-1";
  m2 = "DP-2";
in
{
  cirius.development = {
    git = {
      enable = true;
      userName = user.name;
      userEmail = user.email;
      pager = true;
    };
    langs = {
      go.enable = true;
      node.enable = true;
      nix.enable = true;
    };
    ide = {
      nixvim = {
        enable = true;
        plugins = {
          ai = {
            enable = true;
            # TODO: need instruct model for chat.
            ollamaModel = "qwen2.5-coder:latest"; # deepseek-coder:6.7b | starcoder2:3b | qwen2.5-coder:latest
            ollamaHost = "127.0.0.1:11434";
          };
          debugging.enable = true;
          formatter = {
            enable = true;
          };
        };
      };
      db.enable = true;
      helix.enable = true;
      useJetbrainsNC = true;
    };
    api-client.enable = true;
    kdev.enable = true;
    cli-utils = {
      enable = true;
      fastfetch = {
        enable = true;
      };
      fish = {
        enable = true;
        customPaths = [ "~/Applications" ];
        aliases = {
          "rbnix" = "sudo nixos-rebuild switch --show-trace";
          "nixos-generations" = "nixos-rebuild list-generations";
          "clean-nixos" = "sudo nix-collect-garbage -d && sudo nix-store --gc && sudo nixos-rebuild boot";
          "tf" = "${pkgs.terraform}/bin/terraform";
          "gco" = "${pkgs.git}/bin/git checkout";
          "gpl" = "${pkgs.git}/bin/git pull origin";
          "gps" = "${pkgs.git}/bin/git push origin";
          "gm" = "${pkgs.git}/bin/git merge";
          "gaa" = "${pkgs.git}/bin/git add .";
          "g" = "${pkgs.git}/bin/git";
          "cat" = "${pkgs.bat}/bin/bat";
        };
      };
    };

    infra = {
      enable = true;
    };
    term.enable = true;
  };

  cirius.desktop-environment = {
    kind = "hyprland";
    hyprland = {
      theme = "gruvbox";
      events = {
        onEmptyWorkspaces = {
          "2" = [ "zen" ];
        };
      };
      themes = {
        qt.enable = true;
        gtk.enable = true;
      };
      coreVariables = {
        mainMod = "SUPER";
      };
      screenlock.enable = true;
      services = {
        swaync.enable = true;
        hyprpaper = {
          enable = true;
          wallpapers = [
            ./assets/wallpapers/gruvbox_astro.jpg
          ];
          monitors = [
            {
              name = m2;
              wallpaper = ./assets/wallpapers/gruvbox_astro.jpg;
            }
          ];
        };
      };
      bar = {
        enable = true;
        fullSizeOutputs = [
          m2
        ];
        condensedOutputs = [ ];
      };
    };
  };

  cirius.packages = {
    media.enable = true;
    home-manager = {
      enable = true;
      inherit (user) username;
      inherit (user) name;
      inherit (user) email;
    };
    email.thunderbird.enable = true;
    office.enable = true;
    browsers.enable = true;
    secrets.enable = true;
    fonts.enable = true;
    chat.enable = true;
    stacer.enable = true;
    explorer = {
      enable = true;
      termbased = false;
    };
  };

  cirius.system = {
    xdg.enable = true;
  };
}

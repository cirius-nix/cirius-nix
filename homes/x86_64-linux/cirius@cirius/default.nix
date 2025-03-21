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

  osAICfg = osConfig.cirius.applications.ai;
  ollamaPort = osAICfg.port;

  inherit (lib.cirius) mkEnabled;
in
{
  cirius.development = {
    ai = {
      enable = true;
      tabby = {
        port = 11001;
        localRepos = [ ];
        model = {
          # chat = {
          #   kind = "openai/chat";
          #   model_name = "qwen2.5-coder:7b-base";
          #   api_endpoint = "http://localhost:${builtins.toString ollamaPort}/v1";
          # };
          completion = {
            kind = "ollama/completion";
            api_endpoint = "http://localhost:${builtins.toString ollamaPort}";
            model_name = "qwen2.5-coder:3b-base";
            prompt_template = "<|fim_prefix|> {prefix} <|fim_suffix|>{suffix} <|fim_middle|>";
          };
          embedding = {
            kind = "ollama/embedding";
            model_name = "nomic-embed-text:latest";
            api_endpoint = "http://localhost:${builtins.toString ollamaPort}";
          };
        };
      };
    };
    git = {
      enable = true;
      userName = user.name;
      userEmail = user.email;
      pager = true;
    };
    langs = {
      go.enable = true;
      nix.enable = true;
    };
    ide = {
      nixvim = {
        enable = true;
        plugins = {
          ai = mkEnabled;
          searching = mkEnabled;
          debugging = mkEnabled;
          testing = mkEnabled;
          formatter = mkEnabled;
          languages = {
            dataPresentation = mkEnabled;
            go = mkEnabled;
            lua = mkEnabled;
            markup = mkEnabled;
            nix = mkEnabled;
            shells = mkEnabled;
            sql = mkEnabled;
            terraform = mkEnabled;
            typescript = mkEnabled;
          };
        };
      };
      db = mkEnabled;
      helix = mkEnabled;
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

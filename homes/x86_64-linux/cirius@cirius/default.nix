{
  lib,
  config,
  osConfig,
  pkgs,
  ...
}:
let
  namespace = "cirius";
  ollamaPort = osConfig.${namespace}.applications.ai.port;
  user = config.${namespace}.user;
  inherit (lib.cirius) mkEnabled;
in
{
  ${namespace} = {
    user = {
      email = "hieu.tran21198@gmail.com";
      name = "Minh Hieu Tran";
    };
    development = {
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

    desktop-environment = {
      hyprland =
        let
          monitorID = "DP-2";
        in
        {
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
                  name = monitorID;
                  wallpaper = ./assets/wallpapers/gruvbox_astro.jpg;
                }
              ];
            };
          };
          bar = {
            enable = true;
            fullSizeOutputs = [
              monitorID
            ];
            condensedOutputs = [ ];
          };
        };
    };

    packages = {
      media.enable = true;
      security = {
        enable = true;
        secretFile = builtins.toString ../../../secrets/${user.username}/default.yaml;
      };
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

    system = {
      xdg.enable = true;
    };
  };
}

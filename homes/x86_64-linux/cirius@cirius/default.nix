{
  lib,
  config,
  pkgs,
  ...
}:
let
  namespace = "cirius";
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
          enable = true;
          port = 11001;
          localRepos = [ ];
        };
        mistral = {
          enable = true;
        };
        groq = {
          enable = true;
          nixvimIntegration.enable = true;
        };
        openai = {
          enable = true;
          nixvimIntegration.enable = true;
        };
        ollama = {
          enable = true;
          nixvimIntegration.enable = true;
          continueIntegration = {
            enable = true;
            models = {
              chat = [ "qwen3:4b" ];
              completion = "qwen2.5-coder:3b-base";
              embedding = "nomic-embed-text:latest";
            };
          };
          tabbyIntegration = {
            enable = true;
            completionFIMTemplate = "<|fim_prefix|>{prefix}<|fim_suffix|>{suffix}<|fim_middle|>"; # common
            model = {
              chat = "llama3.1:8b";
              completion = "qwen2.5-coder:3b-base";
              embedding = "nomic-embed-text:latest";
            };
          };
        };
        gemini = {
          enable = true;
          nixvimIntegration.enable = true;
          opencommitIntegration.enable = true;
        };
        deepseek = {
          enable = true;
          nixvimIntegration.enable = true;
          tabbyIntegration = {
            model = {
              chat = "deepseek-chat";
              completion = "deepseek-chat";
            };
          };
        };
        qwen = {
          enable = true;
          nixvimIntegration = {
            enable = true;
            model = "qwen2.5-72b-instruct";
          };
        };

      };
      git = {
        enable = true;
        pager = true;
        includeConfigs = [
          {
            condition = "gitdir:~/Workspace/github/personal/";
            path = "~/.gitconfig.personal";
          }
          {
            condition = "gitdir:~/Workspace/github/work/";
            path = "~/.gitconfig.work";
          }
        ];
      };
      langs = {
        lua.enable = true;
        go = {
          enable = true;
          enableFishIntegration = true;
        };
        nix.enable = true;
        datatype.enable = true;
        markup.enable = true;
        shells.enable = true;
        terraform.enable = true;
        typescript.enable = true;
        java.enable = true;
        sql = {
          enable = true;
          sqlFormatter = {
            settings = {
              # https://github.com/sql-formatter-org/sql-formatter/blob/master/docs/language.md
              # The default "sql" dialect is meant for cases where you don't
              # know which dialect of SQL you're about to format. It's not an
              # auto-detection, it just supports a subset of features common
              # enough in many SQL implementations. This might or might not
              # work for your specific dialect. Better to always pick something
              # more specific if possible.
              # https://en.wikipedia.org/wiki/SQL:2011
              language = "sql";
            };
          };

        };
      };
      ide = {
        nixvim = {
          enable = true;
          colorscheme = "github_dark_dimmed";
          plugins = {
            ai = {
              enable = true;
              avante = {
                provider = "deepseek";
              };
            };
            session = mkEnabled;
            searching = mkEnabled;
            debugging = mkEnabled;
            testing = mkEnabled;
            formatter = mkEnabled;
            git = mkEnabled;
            term = mkEnabled;
          };
        };
        db.enable = true;
        helix.enable = true;
        vscode = {
          enable = true;
          enableVimExt = false;
          enableDockerExts = true;
          enableExtendedExts = true;
          continue = {
            enable = true;
          };
        };
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
        kafka = {
          enable = true;
        };
        langchain = {
          enable = true;
        };
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

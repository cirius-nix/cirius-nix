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
        copilot = {
          enable = true;
          fishIntegration.enable = true;
          vscodeIntegration.enable = true;
        };
        tabby = {
          enable = true;
          port = 11001;
          localRepos = [ ];
          enableNixvimIntegration = true;
        };
        mistral = {
          enable = true;
          continueIntegration = {
            enable = true;
            models.chat = [ "codestral-large-latest" ];
          };
          tabbyIntegration = {
            enable = true;
            model = {
              completion = "codestral-latest";
            };
          };
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
          tabbyIntegration = {
            enable = true;
            model.chat = "qwen3:4b";
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
        vscodeIntegration = {
          enable = true;
          extensions = lib.mkForce (
            with pkgs.vscode-extensions;
            [
              waderyan.gitblame
            ]
          );
        };
        fishIntegration = {
          enable = true;
        };
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
          settings = {
            enableFishIntegration = true;
            useReviserFmt = true;
            nvim = {
              go = { };
            };
          };
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
            term = {
              enable = true;

            };
          };
        };
        db.enable = true;
        helix.enable = true;
        vscode = {
          enable = true;
          exts = {
            vim = true;
            docker = true;
            extended = true;
          };
          continue = {
            enable = true;
          };
          enableFishIntegration = true;
        };
      };
      api-client.enable = true;
      kdev.enable = true;
      cli-utils = {
        enable = true;
        pay-respects.enable = true;
        btop.enable = true;
        amz-q.enable = true;
        amz-q.vscodeIntegration.enable = true;
        starship = {
          enable = true;
        };
        fastfetch = {
          enable = true;
        };
        atuin = {
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
            "cat" = "${pkgs.bat}/bin/bat";
            "ff" = "${pkgs.fastfetch}/bin/fastfetch";
            "q" = "amazon-q";
          };
        };
      };

      infra = {
        enable = true;
        sonarqube = {
          enable = true;
          integrateVSCode = true;
        };
        docker = {
          enable = true;
          enableFishIntegration = true;
        };
        kafka = {
          enable = true;
        };
        langchain = {
          enable = true;
        };
      };
      term = {
        enable = true;
        kitty.enable = true;
        wezterm.enable = true;
        konsole.enable = true;
      };
    };
    desktop-environment = {
      shared.plugins.kvantum.enable = true;
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
      utilities = {
        scrcpy.enable = true;
        android-tools.enable = true;
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
      sync = {
        rclone = {
          enable = true;
          ggdrive = {
            enable = false;
          };
        };
      };
    };

    system = {
      xdg.enable = true;
      themes = {
        preset = "catppuccin";
        isDark = true;
        catppuccin = {
          light = "latte";
          dark = "mocha";
          kde.style = "classic";
          atuin = {
            dark = {
              accent = "sapphire";
            };
          };
          kitty = {
            opacity = 0.95;
            blur = 20;
          };
          konsole = {
            opacity = 5;
            blur = true;
          };
          nixvim.transparent = true;
          btop.transparent = true;
        };
      };
    };
  };
}

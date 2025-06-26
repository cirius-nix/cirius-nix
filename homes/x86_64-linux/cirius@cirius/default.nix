{
  lib,
  pkgs,
  config,
  ...
}:
let
  namespace = "cirius";
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
        lmstudio.enable = true;
        copilot = {
          enable = true;
          fishIntegration.enable = true;
          vscodeIntegration.enable = true;
          nixvimIntegration.enable = true;
        };
        tabby = {
          enable = true;
          port = 11001;
          localRepos = [
            {
              name = "Cirius Nix";
              repo = "${config.${namespace}.user.homeDir}/Workspace/github/personal/cirius-nix/cirius-nix";
            }
            {
              name = "Coding Flow";
              repo = "${config.${namespace}.user.homeDir}/Workspace/github/personal/codingflow";
            }
            {
              name = "Cirius Nix SonarQube";
              repo = "${config.${namespace}.user.homeDir}/Workspace/github/personal/sonarqube";
            }
          ];
          enableNixvimIntegration = false;
        };
        mistral = {
          enable = true;
          continueIntegration = {
            enable = true;
            models.chat = [ "codestral-large-latest" ];
          };
          tabbyIntegration = {
            enable = true;
          };
        };
        groq = {
          enable = true;
          nixvimIntegration = {
            enable = true;
            model = "qwen-qwq-32b";
          };
        };
        openai = {
          enable = true;
          nixvimIntegration = {
            enable = true;
            model = "gpt-4o-mini";
          };
        };
        ollama = {
          enable = true;
          nixvimIntegration = {
            enable = true;
            model = "qwen3:4b";
          };
          tabbyIntegration = {
            enable = true;
            completionFIMTemplate = "<|fim_prefix|>{prefix}<|fim_suffix|>{suffix}<|fim_middle|>";
            model = {
              chat = "qwen3:4b";
              completion = "qwen2.5-coder:3b-base";
              embedding = "nomic-embed-text:latest";
            };
          };
        };
        gemini = {
          enable = true;
          nixvimIntegration = {
            enable = true;
            model = "gemini-2.5-pro";
          };
          opencommitIntegration.enable = true;
        };
        deepseek = {
          enable = true;
          nixvimIntegration.enable = true;
          nixvimIntegration.model = "deepseek-chat";
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
        nixvimIntegration = {
          enable = true;
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
        amz-q = {
          enable = true;
          vscodeIntegration.enable = true;
        };
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
          enableVSCodeIntegration = true;
          enableNixvimIntegration = true;
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

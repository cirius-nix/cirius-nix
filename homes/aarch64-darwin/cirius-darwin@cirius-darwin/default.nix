{
  config,
  lib,
  pkgs,
  ...
}:
let
  namespace = "cirius";
  user = config.${namespace}.user;
  inherit (lib.${namespace}) mkEnabled;
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
        mistral.enable = true;
        groq = {
          enable = true;
          nixvimIntegration.enable = true;
        };
        openai = {
          enable = true;
          nixvimIntegration.enable = true;
        };
        deepinfra = {
          enable = true;
          nixvimIntegration = {
            enable = true;
            model = "Qwen/Qwen3-32B";
          };
          tabbyIntegration = {
            enable = true;
            model.chat = "Qwen/Qwen3-32B";
          };
          continueIntegration = {
            enable = true;
            models = {
              chat = [
                "Qwen/Qwen3-32B"
                "Qwen/Qwen2.5-72B-Instruct"
                "Qwen/Qwen2.5-Coder-32B-Instruct"
                "mistralai/Mistral-Small-24B-Instruct-2501"
                "deepseek-ai/DeepSeek-R1-Turbo"
              ];
            };
          };
        };
        tabby = {
          enable = true;
          port = 11001;
          localRepos = [ ];
          enableNixvimIntegration = true;
        };
        ollama = {
          enable = true;
          continueIntegration = {
            enable = true;
            models = {
              chat = [
                "qwen3:4b"
                "smallthinker:latest"
                "cogito:8b-v1-preview-llama-q4_K_M"
              ];
              completion = "qwen2.5-coder:3b-base";
              embedding = "nomic-embed-text:latest";
            };
          };
          nixvimIntegration = {
            enable = true;
            model = "qwen3:4b";
          };
          tabbyIntegration = {
            enable = true;
            completionFIMTemplate = "<|fim_prefix|>{prefix}<|fim_suffix|>{suffix}<|fim_middle|>";
            model = {
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
        nixvimIntegration.enable = true;
        vscodeIntegration = {
          enable = true;
          extensions = lib.mkForce (
            with pkgs.vscode-extensions;
            [
              waderyan.gitblame
            ]
          );
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
      api-client.enable = true;
      langs = {
        lua.enable = true;
        go = {
          enable = true;
          settings = {
            enableFishIntegration = true;
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
      cli-utils = {
        enable = true;
        pay-respects.enable = true;
        starship.enable = true;
        fastfetch.enable = true;
        atuin.enable = true;
        fish = {
          enable = true;
          customPaths = [ "~/Applications" ];
          aliases = {
            "cat" = "bat";
            "rbnix" = "sudo darwin-rebuild switch --flake .#${user.username}";
            "tf" = "${pkgs.terraform}/bin/terraform";
            "gco" = "${pkgs.git}/bin/git checkout";
            "gpl" = "${pkgs.git}/bin/git pull origin";
            "gps" = "${pkgs.git}/bin/git push origin";
            "gm" = "${pkgs.git}/bin/git merge";
            "ff" = "${pkgs.fastfetch}/bin/fastfetch";
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
        docker.enable = true;
        kafka = {
          enable = true;
        };
        langchain = {
          enable = true;
        };
        github = {
          enable = true;
          act.enable = true;
        };
      };
      ide = {
        db = {
          enable = true;
        };
        vscode = {
          enable = true;
          exts = {
            vim = true;
            docker = true;
            extended = true;
          };
          enableFishIntegration = true;
          continue = {
            enable = true;
          };
          projectRoots = [
            "~/Workspace/github/personal"
            "~/Workspace/github/work"
          ];
        };
        nixvim = {
          enable = true;
          plugins = {
            ai = {
              enable = true;
              avante.provider = "gemini";
            };
            searching = mkEnabled;
            debugging = mkEnabled;
            testing = mkEnabled;
            formatter = mkEnabled;
            term = {
              enable = true;

            };
            session = mkEnabled;
          };
        };
        helix = {
          enable = true;
        };
      };
      term = {
        enable = true;
        kitty.enable = true;
        warp.enable = true;
      };
    };

    packages = {
      chat.enable = true;
      fonts.enable = true;
      utilities = {
        raycast.enable = true;
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

{
  config,
  lib,
  pkgs,
  ...
}:
let
  namespace = "cirius";
  user = config.${namespace}.user;
  ollamaPort = 11000;
  tabbyPort = 11001;
  inherit (lib.${namespace}) mkEnabled;
in
{
  ${namespace} = {
    # TODO: implement user.
    user = {
      email = "hieu.tran21198@gmail.com";
      name = "Minh Hieu Tran";
    };
    development = {
      ai = {
        enable = true;
        tabby = {
          port = tabbyPort;
          localRepos = [
            {
              name = "cirius-nix";
              repo = "${user.homeDir}/Workspace/github/personal/cirius-nix/cirius-nix";
            }
            {
              name = "wbs";
              repo = "${user.homeDir}/Workspace/github/personal/wbs";
            }
            {
              name = "wbs-frontend";
              repo = "${user.homeDir}/Workspace/github/personal/wbs-frontend";
            }
          ];
          model = {
            chat = {
              kind = "openai/chat";
              api_endpoint = "https://api.deepseek.com";
              model_name = "deepseek-chat";
              api_key = config.sops.placeholder."deepseek_auth_token";
            };
            completion = {
              kind = "deepseek/completion";
              api_endpoint = "https://api.deepseek.com/beta";
              model_name = "deepseek-chat";
              api_key = config.sops.placeholder."deepseek_auth_token";
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
        opencommit = {
          # preset = "ollama";
          # model = "cogito:8b-v1-preview-llama-q4_K_M";
          # model = "mistral:7b";
          # preset = "deepseek"; # unchecked
          # model = "deepseek-chat";
          # preset = "groq"; -> not quite good
          # model = "llama3-70b-8192";
          preset = "gemini";
          model = "gemini-2.0-flash";
        };
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
            "cat" = "bat";
            "rbnix" = "sudo darwin-rebuild switch --flake .#${user.username}";
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
              avante = {
                preset = "qwen";
                reasoningModel = "qwq-plus";
              };
            };
            git = mkEnabled;
            searching = mkEnabled;
            debugging = mkEnabled;
            testing = mkEnabled;
            formatter = mkEnabled;
            term = mkEnabled;
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
        helix = {
          enable = true;
        };
      };
      term.enable = true;
    };

    packages = {
      home-manager = {
        enable = true;
        inherit (user) username name email;
      };
      security = {
        enable = true;
        secretFile = ../../../secrets/${user.username}/default.yaml;
      };
      fonts.enable = true;
    };
  };
}

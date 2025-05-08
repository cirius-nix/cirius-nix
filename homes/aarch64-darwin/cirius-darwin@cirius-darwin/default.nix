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
    # TODO: implement user.
    user = {
      email = "hieu.tran21198@gmail.com";
      name = "Minh Hieu Tran";
    };
    development = {
      ai = {
        enable = true;
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
          nixvimIntegration = {
            enable = true;
            model = "smallthinker";
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
          tabbyIntegration = {
            enable = false;
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
        tabby = {
          enable = true;
          port = 11001;
          localRepos = [ ];
        };
      };
      git = {
        enable = true;
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
              avante.provider = "gemini";
            };
            git = mkEnabled;
            searching = mkEnabled;
            debugging = mkEnabled;
            testing = mkEnabled;
            formatter = mkEnabled;
            term = mkEnabled;
            session = mkEnabled;
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
      term.warp.enable = true;
    };

    packages = {
      home-manager = {
        enable = true;
        inherit (user) username name email;
      };
      fonts.enable = true;
    };
  };
}

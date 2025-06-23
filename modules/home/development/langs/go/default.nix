{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf optionals;
  inherit (config.${namespace}.development.langs) go;
in
{
  options.${namespace}.development.langs.go = {
    enable = mkEnableOption "Golang";
    settings = {
      useReviserFmt = mkEnableOption "Use goimports-reviser to re-format document";
      enableFishIntegration = mkEnableOption "enable fish integration";
      nvim = {
        go = { };
      };
    };
  };

  config = mkIf go.enable {
    home.packages = [
      pkgs.go
      pkgs.gotools

    ] ++ (optionals go.settings.useReviserFmt [ pkgs.goimports-reviser ]);
    programs.nixvim = {
      extraPlugins = with pkgs; [
        vimPlugins.go-nvim
      ];
      extraConfigLuaPost = ''
        vim.filetype.add({
          extension = {
            gotmpl = 'gotmpl',
          },
          pattern = {
            [".*/templates/.*%.tpl"] = "helm",
            [".*/templates/.*%.ya?ml"] = "helm",
            ["helmfile.*%.ya?ml"] = "helm",
          },
        })

        local ok, go = pcall(require, 'go')
        if not ok then 
          return
        end

        go.setup({

        })
      '';
      lsp.servers.gopls = {
        enable = true;
        name = "gopls";
      };
      plugins = {
        none-ls = {
          sources.code_actions = {
            gomodifytags.enable = true;
            impl.enable = true;
          };
        };
        conform-nvim.settings = {
          formatters = {
            goimports = {
              command = "${pkgs.gotools}/bin/goimports";
            };
            goimports-reviser = {
              command = lib.getExe pkgs.goimports-reviser;
            };
          };
          formatters_by_ft = {
            go = [
              "goimports"
            ] ++ (optionals go.settings.useReviserFmt [ "goimports-reviser" ]);
          };
        };
      };
    };

    programs.vscode.profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        golang.go
      ];
    };

    ${namespace} = {
      development = {
        cli-utils.fish = mkIf go.settings.enableFishIntegration {
          interactiveEnvs = {
            GOBIN = "$HOME/go/bin";
          };
          customPaths = [ "$GOBIN" ];
        };
      };
    };
  };
}

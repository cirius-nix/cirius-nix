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
        settings = {
          gopls = {
            gofumpt = true;
            codelenses = {
              gc_details = false;
              generate = true;
              regenerate_cgo = true;
              run_govulncheck = true;
              test = true;
              tidy = true;
              upgrade_dependency = true;
              vendor = true;
            };
            hints = {
              assignVariableTypes = true;
              compositeLiteralFields = false;
              compositeLiteralTypes = false;
              constantValues = false;
              functionTypeParameters = true;
              parameterNames = false;
              rangeVariableTypes = false;
            };
            usePlaceholders = true;
            completeUnimported = true;
            staticcheck = true;
            directoryFilters = [
              "-.git"
              "-.vscode"
              "-.idea"
              "-.vscode-test"
              "-node_modules"
            ];
            semanticTokens = true;
          };
        };
      };
      plugins = {
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

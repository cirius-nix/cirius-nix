{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.${namespace}.development.langs.go;
in
{
  options.${namespace}.development.langs.go = {
    enable = mkEnableOption "Golang";
    enableFishIntegration = mkEnableOption "enable fish integration";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      go

      # tools
      gotools
      goimports-reviser
      gomodifytags
      impl

      air
      wails

      # OpenAPI tools
      go-swagger
      go-swag
    ];

    programs.nixvim = {
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
      '';
      plugins = {

        lsp.servers = {
          gopls = {
            enable = true;
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
              "goimports-reviser"
            ];
          };
        };
      };
    };

    ${namespace} = {
      development = {
        cli-utils.fish = mkIf cfg.enableFishIntegration {
          interactiveEnvs = {
            GOBIN = "$HOME/go/bin";
          };
          customPaths = [ "$GOBIN" ];
        };
      };
    };
  };
}

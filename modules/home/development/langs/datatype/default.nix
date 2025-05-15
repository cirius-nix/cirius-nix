{
  namespace,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.${namespace}.development.langs.datatype;
  inherit (config.${namespace}.development.ide) vscode nixvim;
in
{
  options.${namespace}.development.langs.datatype = {
    enable = mkEnableOption "Enable Data Presentation Language Server";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      jq
    ];
    programs = {
      vscode = mkIf vscode.enable {
        profiles.default = {
          extensions = with pkgs.vscode-extensions; [
            tamasfe.even-better-toml
          ];
        };
      };
      nixvim.plugins = mkIf nixvim.enable {
        schemastore = {
          # https://github.com/SchemaStore/schemastore/blob/master/src/api/json/catalog.json
          enable = true;
          # Whether to enable the json schemas in jsonls | yamlls.
          json = {
            enable = true;
          };
          yaml = {
            enable = true;
            settings = {
              extra = [
                # serverless configuration.
                {
                  description = "Extended file types for serverless";
                  fileMatch = "*serverless*.{yml,yaml}";
                  name = "Serverless";
                  url = "https://raw.githubusercontent.com/lalcebo/json-schema/master/serverless/reference.json";
                }
                # docker compose configuration.
                {
                  description = "Extended file types for docker-compose";
                  fileMatch = "*docker-compose*.{yml,yaml}";
                  name = "Docker Compose";
                  url = "https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json";
                }
              ];
            };
          };
        };
        lsp.servers = {
          # https://github.com/Microsoft/vscode/blob/main/extensions/json-language-features/server/README.md
          # https://github.com/hrsh7th/vscode-langservers-extracted
          jsonls = {
            enable = true;
          };
          yamlls = {
            enable = true;
          };
        };
        conform-nvim.settings = {
          # INFO: custom formatter to be used.
          formatters = {
            xmlformat = {
              command = lib.getExe pkgs.xmlformat;
            };
            yamlfmt = {
              command = lib.getExe pkgs.yamlfmt;
            };
            prettier = {
              command = lib.getExe pkgs.nodePackages.prettier;
            };
            prettierd = {
              command = lib.getExe pkgs.prettierd;
            };
            taplo = {
              command = lib.getExe pkgs.taplo;
            };
            jq = {
              command = lib.getExe pkgs.jq;
            };
          };

          # INFO: use formatter(s).
          formatters_by_ft = {
            xml = [ "xmlformat" ];
            yaml = [ "yamlfmt" ];
            toml = [ "taplo" ];
            typescriptreact = [
              "prettierd"
              "prettier"
            ];
            javascriptreact = [
              "prettierd"
              "prettier"
            ];
            json = [
              "jq"
              "prettierd"
              "prettier"
            ];
          };
        };
      };
    };
  };
}

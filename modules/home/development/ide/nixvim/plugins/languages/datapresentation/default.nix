{
  namespace,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    ;

  inherit (lib.${namespace}.nixvim) mkEnabled;

  cfg = config.${namespace}.development.ide.nixvim.plugins.languages.dataPresentation;
in
{
  options.${namespace}.development.ide.nixvim.plugins.languages.dataPresentation = {
    enable = mkEnableOption "Enable Data Presentation (TOML, YAML, JSON, JSONC, StrictYAML, XML...) Language Server";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      jq
    ];
    programs.nixvim.plugins = {
      lsp.servers = {
        jsonls = mkEnabled;
        yamlls = {
          enable = true;
          extraOptions = {
            settings = {
              yaml = {
                schemas = {
                  kubernetes = "'*.yaml";
                  "http://json.schemastore.org/github-workflow" = ".github/workflows/*";
                  "http://json.schemastore.org/github-action" = ".github/action.{yml,yaml}";
                  "https://json.schemastore.org/dependabot-v2" = ".github/dependabot.{yml,yaml}";
                  "https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json" =
                    "*docker-compose*.{yml,yaml}";
                  "https://raw.githubusercontent.com/lalcebo/json-schema/master/serverless/reference.json" =
                    "*serverless*.{yml,yaml}";
                };
              };
            };
          };
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
          json = [
            "jq"
            "prettier"
          ];
        };
      };
    };
  };
}

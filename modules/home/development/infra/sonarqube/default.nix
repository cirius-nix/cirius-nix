{
  config,
  namespace,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (config.${namespace}) user;
  inherit (config.${namespace}.development.infra) sonarqube;
  inherit (config.${namespace}.development.ide) nixvim vscode;
  inherit (config.${namespace}.development.cli-utils) fish;
in
{
  options.${namespace}.development.infra.sonarqube = {
    enable = mkEnableOption "Enable sonarqube";
    enableVSCodeIntegration = mkEnableOption "Integrating with VSCode";
    enableNixvimIntegration = mkEnableOption "Enable Nixvim Integration";
  };
  config = mkIf sonarqube.enable {
    home.packages = [
      pkgs.${namespace}.sonarlint-vscode
    ];

    programs.nixvim = mkIf (nixvim.enable && sonarqube.enableNixvimIntegration) {
      extraPlugins = [
        pkgs.vimPlugins.sonarlint-nvim
      ];
      extraConfigLua = ''
        require("sonarlint").setup {
          server = {
              cmd = {
                "${pkgs.jdk17_headless}/bin/java",
                "-jar",
                "${pkgs.${namespace}.sonarlint-vscode}/extension/server/sonarlint-ls.jar",
                "-stdio",
                "-analyzers",
                "${pkgs.${namespace}.sonarlint-vscode}/analyzers/sonargo.jar",
                "${pkgs.${namespace}.sonarlint-vscode}/analyzers/sonarhtml.jar",
                "${pkgs.${namespace}.sonarlint-vscode}/analyzers/sonarjs.jar",
                "${pkgs.${namespace}.sonarlint-vscode}/analyzers/sonariac.jar",
                "${pkgs.${namespace}.sonarlint-vscode}/analyzers/sonarjava.jar",
                "${pkgs.${namespace}.sonarlint-vscode}/analyzers/sonarjavasymbolicexecution.jar",
                "${pkgs.${namespace}.sonarlint-vscode}/analyzers/sonarpython.jar",
                "${pkgs.${namespace}.sonarlint-vscode}/analyzers/sonartext.jar",
              },
          },
          filetypes = {
              "go",
              "html",
              "javascript",
              "python",
              "html",
              "typescript",
              "java",
          },
        }
      '';
    };

    sonarqube.services.sonarqube = {
      enable = true;
      jdk = pkgs.jdk17_headless;
      stateDir = "${user.homeDir}/.local/state/sonarqube";
      fishIntegration = {
        enable = fish.enable;
        alias = "sq";
      };
    };

    programs.vscode.profiles.default = mkIf (vscode.enable && sonarqube.enableVSCodeIntegration) {
      userSettings = {
        "sonarlint.connectedMode.connections.sonarqube" = [
          {
            "serverUrl" = "http://localhost:9000";
            "connectionId" = "http-localhost-9000";
          }
        ];
      };
      extensions = with pkgs.nix-vscode-extensions.vscode-marketplace; [
        sonarsource.sonarlint-vscode
      ];
    };
  };
}

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
  sonarqube = config.${namespace}.development.infra.sonarqube;
  vscode = config.${namespace}.development.ide.vscode;
in
{
  options.${namespace}.development.infra.sonarqube = {
    enable = mkEnableOption "Enable sonarqube";
    integrateVSCode = mkEnableOption "Integrating with VSCode";
  };
  config = mkIf sonarqube.enable {
    home.packages = with pkgs; [
      sonarlint-ls
      sonar-scanner-cli
    ];

    # sonarqube.services.sonarqube = {
    #   enable = true;
    #   jdk = pkgs.jdk17_headless;
    #   stateDir = "${user.homeDir}/.local/state/sonarqube";
    # };

    programs.vscode.profiles.default = mkIf (vscode.enable && sonarqube.integrateVSCode) {
      extensions = with pkgs.nix-vscode-extensions.vscode-marketplace; [
        sonarsource.sonarlint-vscode
      ];
    };
  };
}

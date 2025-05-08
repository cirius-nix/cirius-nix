{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.development.infra;
in
{
  options.${namespace}.development.infra = {
    enable = mkEnableOption "Infrastructure applications";
  };

  config = mkIf cfg.enable {
    ${namespace}.development = {
      ide.vscode.addPlugins = with pkgs.vscode-extensions; [
        hashicorp.terraform
      ];
      cli-utils.fish = {
        interactiveFuncs = {
          aws_profile = ''
            set profile $argv[1]
            set -e argv[1]

            ${pkgs.aws-vault}/bin/aws-vault exec $profile fish -d 12h $argv
          '';
          aws_log_func = ''
            aws logs tail "/aws/lambda/$argv[1]" --follow --format json
          '';
        };
      };
    };

    home.packages = with pkgs; [
      awscli2
      aws-vault
      chamber

      terraform

      serverless

      pulumi
      pulumi-esc
      pulumiPackages.pulumi-go
      pulumiPackages.pulumi-nodejs
    ];
  };
}

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
    home.packages = with pkgs; [
      awscli2
      aws-vault
      chamber

      terraform

      serverless

      pulumi
      pulumi-esc
      pulumiPackages.pulumi-language-go
      pulumiPackages.pulumi-language-nodejs
    ];
  };
}

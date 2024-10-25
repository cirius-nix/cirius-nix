{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;

  devCfg = config.cirius.development;
  cfg = devCfg.aws;
in
{
  options.cirius.development.aws = {
    enable = mkEnableOption "AWS";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      awscli2
      aws-vault
      chamber
      terraform
      serverless
    ];
  };
}

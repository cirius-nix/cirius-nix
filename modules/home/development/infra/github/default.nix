{
  config,
  namespace,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption optionals;
  inherit (config.${namespace}.development.infra) github;
in
{
  options.${namespace}.development.infra.github = {
    enable = mkEnableOption "Enable development infrastructure";
    act = {
      enable = mkEnableOption "Enable github act plugin";
    };
  };

  config = mkIf github.enable {
    home.packages = with pkgs; [
      (optionals github.act.enable act)
    ];
  };
}

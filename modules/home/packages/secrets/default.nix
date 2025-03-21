{
  config,
  pkgs,
  lib,
  namespace,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.${namespace}.packages.secrets;
in
{
  options.${namespace}.packages.secrets = {
    enable = mkEnableOption "secrets";
  };

  config = mkIf cfg.enable {
    ${namespace}.desktop-environment.hyprland = {
      rules = {
        winv2 = {
          float = {
            "" = [ "class:Enpass" ];
          };
        };
      };
    };
    home = {
      packages = with pkgs; [
        enpass
      ];
    };
  };
}

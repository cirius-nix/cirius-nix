{
  config,
  pkgs,
  lib,
  namespace,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.${namespace}) mkEnumOption;
  cfg = config.${namespace}.packages.secrets;
in
{
  options.${namespace}.packages.secrets = {
    enable = mkEnableOption "secrets";
    packages = mkEnumOption (with pkgs; [
      enpass
    ]) pkgs.enpass "Package to manage secrets";
  };

  config = mkIf cfg.enable {
    ${namespace} = lib.optionalAttrs pkgs.stdenv.isLinux {
      desktop-environment.hyprland = {
        rules = {
          winv2 = {
            float = {
              "" = [ "class:Enpass" ];
            };
          };
        };
      };
    };
    home = {
      packages = with pkgs; [
        enpass
        # TODO:
        # pkgs.${namespace}.enpass-cli
      ];
    };
  };
}

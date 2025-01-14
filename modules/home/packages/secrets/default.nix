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
    home = {
      packages = with pkgs; [
        enpass
      ];
    };
  };
}

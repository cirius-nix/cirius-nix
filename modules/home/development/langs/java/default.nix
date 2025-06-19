{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.development.langs.java;
in
{
  options.${namespace}.development.langs.java = {
    enable = mkEnableOption "Java";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
    ];
  };
}

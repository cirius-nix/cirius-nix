{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.cirius.development.java;
in
{
  options.cirius.development.java = {
    enable = mkEnableOption "Java";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      jdk
    ];
  };
}

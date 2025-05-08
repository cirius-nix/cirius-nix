{
  pkgs,
  lib,
  namespace,
  config,
  ...
}:
let
  cfg = config.${namespace}.development.term.warp;
in
{
  options.${namespace}.development.term.warp = {
    enable = lib.mkEnableOption "Enable warp terminal";
  };
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      warp-terminal
    ];
  };
}

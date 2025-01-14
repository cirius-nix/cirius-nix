{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.${namespace}.development.ide.helix;
in
{
  options.${namespace}.development.ide.helix = {
    enable = mkEnableOption "helix";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      helix
    ];
  };
}

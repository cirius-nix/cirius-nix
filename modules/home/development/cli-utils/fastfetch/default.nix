{
  config,
  namespace,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption;
  cfg = config.${namespace}.development.cli-utils.fastfetch;
in
{
  options.${namespace}.development.cli-utils.fastfetch = {
    enable = mkEnableOption "FastFetch";
  };

  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        fastfetch
      ];
    };
  };
}

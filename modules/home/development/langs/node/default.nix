{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.${namespace}.development.langs.node;
in
{
  options.${namespace}.development.langs.node = {
    enable = mkEnableOption "NodeJS";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      nodejs_22
      corepack_22
    ];
  };
}

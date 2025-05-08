{
  namespace,
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.${namespace}.development.ide.vscode;
  inherit (lib) mkIf mkEnableOption;
in
{
  options.${namespace}.development.ide.vscode = {
    enable = mkEnableOption "VSCode development environment";
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      vscode
    ];
  };
}

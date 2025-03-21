{
  config,
  pkgs,
  lib,
  namespace,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.${namespace}.packages.office;
in
{
  options.${namespace}.packages.office = {
    enable = mkEnableOption "office";
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        libreoffice-qt6
        obsidian
        obsidian-export
      ];
    };
  };
}

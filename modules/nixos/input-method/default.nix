{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.cirius.input-method;
  kdeCfg = config.cirius.kde;
in
{
  options.cirius.input-method = {
    enable = mkEnableOption "Input Method";
  };

  config = mkIf cfg.enable {
    i18n.inputMethod = {
      enabled = "fcitx5";
      fcitx5 = {
        waylandFrontend = true;
        addons =
          if kdeCfg.enable then
            [
              pkgs.fcitx5-bamboo
              pkgs.kdePackages.fcitx5-unikey
              pkgs.kdePackages.fcitx5-qt
              pkgs.kdePackages.fcitx5-configtool
            ]
          else
            [ ];
      };
    };
  };
}

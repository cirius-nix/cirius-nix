{
  config,
  lib,
  namespace,
  pkgs,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.${namespace}.core.input-method;
in
{
  options.${namespace}.core.input-method = {
    enable = mkEnableOption "Input Method";
  };

  config = mkIf cfg.enable {
    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5 = {
        waylandFrontend = true;
        addons = with pkgs; [
          fcitx5-bamboo
          fcitx5-gtk
          kdePackages.fcitx5-unikey
          kdePackages.fcitx5-qt
          kdePackages.fcitx5-configtool
        ];
      };
    };
  };
}

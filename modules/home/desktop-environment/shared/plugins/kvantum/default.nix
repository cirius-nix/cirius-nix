{
  config,
  namespace,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (config.${namespace}.desktop-environment.shared.plugins) kvantum;
in
{
  options.${namespace}.desktop-environment.shared.plugins.kvantum = {
    enable = mkEnableOption "Enable Kvantum theme engine";
    settings = lib.mkOption {
      type = lib.types.attrs;
      default = {
      };
      description = ''
        Settings for Kvantum theme engine.
      '';
    };
  };
  config = mkIf kvantum.enable {
    xdg.configFile = {
      "Kvantum/kvantum.kvconfig".text = lib.generators.toINI { } kvantum.settings;
    };
    home.packages = with pkgs; [
      qt6Packages.qtstyleplugin-kvantum
    ];
  };
}

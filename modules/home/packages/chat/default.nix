{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.${namespace}.packages.chat;
in
{
  options.${namespace}.packages.chat = {
    enable = mkEnableOption "Chat";
  };

  config = mkIf cfg.enable {
    ${namespace} = lib.optionalAttrs pkgs.stdenv.isLinux {
      desktop-environment.hyprland = {
        rules.winv2.workspace = {
          "5 silent" = [
            "class:^(org.telegram.desktop)$"
            "class:^(discord)$"
            "class:^(Caprine)$"
          ];
        };
      };
    };
    home.packages = with pkgs; [
      # FIXME: telegram desktop doesn't support aarch64-darwin on the latest build
      # telegram-desktop
      caprine
      discord
      # broken
      # element
    ];
  };
}

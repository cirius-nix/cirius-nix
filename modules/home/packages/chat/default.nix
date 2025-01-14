{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.cirius.packages.chat;
in
{
  options.cirius.packages.chat = {
    enable = mkEnableOption "Chat";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      telegram-desktop
    ];
  };
}

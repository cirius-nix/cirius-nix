{
  config,
  pkgs,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.${namespace}.applications.cli-utils;
in
{
  options = {
    ${namespace}.applications.cli-utils = {
      enable = mkEnableOption "CLI Utilities";
    };
  };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      dmidecode
      fwup
      fwupd
    ];
    services.fwupd.enable = true;
    programs.mtr.enable = true;
    programs.gnupg.agent = {
      enable = true;
    };
  };
}

{
  config,
  lib,
  namespace,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;
  cfg = config.${namespace}.core.keyring;
in
{
  options.${namespace}.core.keyring = {
    enable = mkBoolOpt false "Enable keyring applications";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      kwalletcli
      kdePackages.kwallet
      kdePackages.kwallet-pam
      kdePackages.kwalletmanager
      kdePackages.ksshaskpass
      kdePackages.signon-kwallet-extension
    ];
  };
}

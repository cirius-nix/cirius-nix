{
  config,
  lib,
  namespace,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.${namespace}.packages.email.thunderbird;
in
{
  options.${namespace}.packages.email.thunderbird = {
    enable = mkEnableOption "thunderbird";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      thunderbird
    ];
  };
}

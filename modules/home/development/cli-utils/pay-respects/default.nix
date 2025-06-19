{
  config,
  namespace,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (config.${namespace}.development.cli-utils) pay-respects fish;
in
{
  options.${namespace}.development.cli-utils.pay-respects = {
    enable = mkEnableOption "Enable pay-respects";
  };
  config = mkIf (pay-respects.enable) {
    programs.pay-respects = {
      enable = true;
      enableFishIntegration = fish.enable;
      package = pkgs.pay-respects;
    };
  };
}

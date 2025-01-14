{
  config,
  namespace,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkOption types;
  cfg = config.${namespace}.motherboard;
in
{
  options.${namespace}.motherboard = {
    enable = lib.mkEnableOption "Motherboard";
    motherboard = mkOption {
      type = types.nullOr (
        types.enum [
          "amd"
          "intel"
        ]
      );
      default = "amd";
      description = lib.mdDoc "CPU family of motherboard. Allows for addition motherboard i2c support.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      # Motherboard packages
      lm_sensors
      openrgb-with-all-plugins
      i2c-tools
    ];
    services.hardware.openrgb = {
      enable = true;
      inherit (cfg) motherboard;
    };
  };
}

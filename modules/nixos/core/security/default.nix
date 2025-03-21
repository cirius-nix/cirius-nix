{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.core.security;
in
{
  options.${namespace}.core.security = {
    enable = mkEnableOption "Security";
  };

  config = mkIf cfg.enable {
    security.rtkit = {
      inherit (cfg) enable;
    };
    security.polkit = {
      enable = true;
    };
  };
}

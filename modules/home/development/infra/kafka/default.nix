{
  config,
  lib,
  namespace,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.${namespace}.development.infra.kafka;
in
{
  options.${namespace}.development.infra.kafka = {
    enable = mkEnableOption "Infrastructure applications";
  };

  config = mkIf cfg.enable {
  };
}

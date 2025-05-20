{
  config,
  osConfig,
  namespace,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  postgres = config.${namespace}.development.infra.postgres;
  postgresOS = osConfig.${namespace}.applications.postgres;
in
{
  options.${namespace}.development.infra.postgres = {
  };
  config = mkIf postgresOS.enable {
  };
}

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
in
{
  options.${namespace}.development.infra.postgres = {
  };
}

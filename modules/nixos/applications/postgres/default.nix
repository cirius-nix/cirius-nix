{
  config,
  namespace,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (lib.${namespace}) mkIntOption;

  postgres = config.${namespace}.applications.postgres;
in
{
  options.${namespace}.applications.postgres = {
    enable = mkEnableOption "Enable postgres";
    port = mkIntOption 5432 "Port of postgres";
  };
  config = mkIf postgres.enable {
    services.postgres = {
      enable = true;
      settings = {
        port = postgres.port;
      };
      extensions =
        ps: with ps; [
          postgis
          pg_repack
        ];
    };
  };
}

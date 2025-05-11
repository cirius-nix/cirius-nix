{
  config,
  lib,
  namespace,
  pkgs,
  ...
}:
let
  cfg = config.${namespace}.packages.sync.minio;
  inherit (lib) mkIf mkEnableOption;
in
{
  options.${namespace}.packages.sync.minio = {
    enable = mkEnableOption "Enable Minio Client";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      minio-client
    ];
  };
}

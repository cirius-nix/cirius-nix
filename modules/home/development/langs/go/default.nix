{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.${namespace}.development.langs.go;
in
{
  options.${namespace}.development.langs.go = {
    enable = mkEnableOption "Golang";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      go
      gotools
      goimports-reviser
      gomodifytags
      go-swagger
      impl
      air
    ];
  };
}

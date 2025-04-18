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
    ${namespace} = {
      development = {
        cli-utils.fish = {
          interactiveEnvs = {
            GOBIN = "$HOME/go/bin";
          };
          customPaths = [ "$GOBIN" ];
        };
        ide.nixvim = {
          plugins = {
            languages = {
              go = {
                enable = true;
              };
            };
          };
        };
      };
    };

    home.packages = with pkgs; [
      wails
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

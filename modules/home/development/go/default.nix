{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.cirius.development.go;
in
{
  options.cirius.development.go = {
    enable = mkEnableOption "Golang";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      go
      gotools
      goimports-reviser
    ];
    # config.cirius.development.fish.customPaths = [
    #   "${pkgs.go}/bin"
    #   "~/go/bin"
    # ];
  };
}

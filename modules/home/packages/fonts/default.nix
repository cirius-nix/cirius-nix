{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.cirius.packages.fonts;
in
{
  options.cirius.packages.fonts = {
    enable = mkEnableOption "fonts";
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        meslo-lgs-nf
        cascadia-code
      ];
    };
  };
}

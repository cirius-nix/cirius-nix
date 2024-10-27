{ config
, lib
, pkgs
, ...
}:

let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.cirius.development.jetbrains;
in
{
  options.cirius.development.jetbrains = {
    enable = mkEnableOption "Jetbrains";
    noncommercial = mkEnableOption "Noncommercial";
  };

  config = mkIf cfg.enable {
    home.packages = mkIf
      cfg.noncommercial
      (with pkgs.jetbrains;
      [
        webstorm
        rider
        writerside
      ]);
  };
}

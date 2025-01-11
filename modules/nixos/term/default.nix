{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.cirius.term;
in
{
  options.cirius.term = {
    enable = mkEnableOption "term";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      ghostty
    ];
  };
}

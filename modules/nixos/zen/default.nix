{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.cirius.zen;
in
{
  options.cirius.zen = {
    enable = mkEnableOption "zen";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      zenmonitor
    ];
  };
}

{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.core.audio;
in
{
  options.${namespace}.core.audio = {
    enable = mkEnableOption "audio";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      wireplumber
      pipewire
    ];
    security.rtkit.enable = true;
    services = {
      pipewire = {
        enable = true;
        pulse.enable = true;
      };
    };
  };
}

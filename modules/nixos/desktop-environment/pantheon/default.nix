{
  config,
  lib,
  namespace,
  ...
}:

let
  inherit (lib) mkIf;
  deCfg = config.${namespace}.desktop-environment;
in
{
  config = mkIf (deCfg.kind == "pantheon") {
    services = {
      xserver = {
        enable = true;
        # This automatically enables LightDM and Pantheon's LightDM greeter. If you'd like to disable this, set
        desktopManager.pantheon.enable = true;
        xkb = {
          layout = "us";
          variant = "";
        };
      };
      printing.enable = false;

      # opt-services.xserver.desktopManager.pantheon.extraWingpanelIndicators
      # opt-services.xserver.desktopManager.pantheon.extraSwitchboardPlugs

      # wingpanel-with-indicators.override {
      #   indicators = [
      #     pkgs.some-special-indicator
      #   ];
      # };
      #
      # switchboard-with-plugs.override {
      #   plugs = [
      #     pkgs.some-special-plug
      #   ];
      # };
      #
      # flatpak remote-add --if-not-exists appcenter https://flatpak.elementary.io/repo.flatpakrepo
    };
  };
}

{
  config,
  namespace,
  ...
}:
let
  deCfg = config.${namespace}.desktop-environment;
in
{
  options = {
    ${namespace}.desktop-environment.uswm = {
    };
  };
  config = {
    programs.uwsm.enable = true;
    # programs.uwsm.waylandCompositors = {
    #   sway = {
    #     prettyName = "sway";
    #   };
    # };
    # // (
    #   if deCfg.kind == "hyprland" then
    #     {
    #       hyprland = {
    #         prettyName = "hyprland";
    #         binPath = "/run/current-system/sw/bin/Hyprland";
    #       };
    #     }
    #   else
    #     { }
    # );
  };
}

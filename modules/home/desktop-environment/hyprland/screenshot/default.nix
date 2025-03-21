{
  config,
  lib,
  namespace,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
  deCfg = config.${namespace}.desktop-environment;
in
{
  config = mkIf (deCfg.kind == "hyprland") {
    ${namespace}.desktop-environment.hyprland = {
      variables =
        let
          getDateTime = lib.getExe (pkgs.writeShellScriptBin "getDateTime" ''echo $(date +'%Y%m%d_%H%M%S')'');
          grimblast = lib.getExe pkgs.grimblast;
        in
        {
          screenshot-path = "$HOME/Pictures/screenshots";
          grimblast_area_file = ''file="$screenshot-path/$(${getDateTime}).png" && ${grimblast} --freeze --notify save area "$file"'';
          grimblast_area_clipboard = "${grimblast} --freeze --notify copy area";
        };
      shortcuts = [
        "$mainMod_SHIFT, S, exec, $grimblast_area_clipboard"
      ];
    };
    home.packages = with pkgs; [
      grimblast
    ];
  };
}

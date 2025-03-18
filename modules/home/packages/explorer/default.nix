# getExe: Package "dolphin-24.12.0.1" does not have the meta.mainProgram
# attribute. We'll assume that the main program has the same name for now, but
# this behavior is deprecated, because it leads to surprising errors when the
# assumption does not hold. If the package has a main program, please set
# `meta.mainProgram` in its definition to make this warning go away. Otherwise,
# if the package does not have a main program, or if you don't control its
# definition, use getExe' to specify the name to the program, such as lib.getExe'
# foo "bar".
{
  config,
  pkgs,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  termCfg = config.${namespace}.development.term;
  cfg = config.${namespace}.packages.explorer;

  # supportedTerm for Yazi.
  supportedTerm = [
    "kitty"
  ];

  enabledTerm = cfg.termbased && termCfg.enable && (lib.elems termCfg.main supportedTerm);
in
{
  options.${namespace}.packages.explorer = {
    enable = mkEnableOption "Explorer";
    termbased = mkEnableOption "Term-based";
  };
  config = mkIf cfg.enable {
    ${namespace}.desktop-environment.hyprland = {
      variables = {
        "explorer" =
          if enabledTerm then
            "$term ${lib.getExe pkgs.yazi}"
          else
            lib.getExe' pkgs.kdePackages.dolphin "dolphin";
      };
      shortcuts = [ "$mainMod, E, exec, $explorer" ];
    };
    home.packages =
      with pkgs;
      [
      ]
      ++ (if enabledTerm then [ yazi ] else [ kdePackages.dolphin ]);
  };
}

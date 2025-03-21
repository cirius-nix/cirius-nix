{
  lib,
  namespace,
  osConfig,
  pkgs,
  ...
}:
let
  inherit (lib.${namespace}) mkEnumOption;
in
{
  options.${namespace} = {
    desktop-environment =
      if (!pkgs.stdenv.isDarwin) then
        {
          kind = mkEnumOption [
            "kde"
            "hyprland"
            "gnome"
            "pantheon"
            "deepin"
          ] osConfig.${namespace}.desktop-environment.kind "Desktop Environment";
        }
      else
        { };
  };
}

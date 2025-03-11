{
  lib,
  namespace,
  ...
}:
let
  inherit (lib.${namespace}) mkEnumOption;
in
{
  options.${namespace} = {
    desktop-environment = {
      kind = mkEnumOption [
        "kde"
        "hyprland"
        "gnome"
        "pantheon"
        "deepin"
      ] "kde" "Desktop Environment";
    };
  };
}

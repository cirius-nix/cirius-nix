{
  namespace,
  lib,
  ...
}:
let
  inherit (lib.${namespace}) mkEnumOption';
  inherit (import ./constants.nix) variants;
in
{
  options.${namespace}.system.themes.catppuccin = {
    light = mkEnumOption' variants "latte" "Light theme";
    dark = mkEnumOption' variants "mocha" "Dark theme";
  };
}

{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (lib.${namespace}) mkStrOption mkListOption;
  cfg = config.${namespace}.fonts;
in
{
  options.${namespace}.fonts = {
    enable = mkEnableOption "Whether or not to manage fonts.";
    fonts = mkListOption lib.types.package (with pkgs; [
      # Desktop Fonts
      corefonts # MS fonts
      work-sans
      source-sans
      inter
      nerd-fonts.monaspace
      nerd-fonts.iosevka
      nerd-fonts.symbols-only
    ]) "Custom font packages to install.";
    default = mkStrOption "Work Sans" "Default font to be used";
  };

  config = mkIf cfg.enable {
    environment.variables = {
      LOG_ICONS = "true";
    };
  };
}

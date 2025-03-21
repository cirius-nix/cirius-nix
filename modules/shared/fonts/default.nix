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
      b612 # high legibility
      material-icons
      material-design-icons
      work-sans
      comic-neue
      source-sans
      inter
      lexend

      # Emojis
      noto-fonts-color-emoji
      twemoji-color-font
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

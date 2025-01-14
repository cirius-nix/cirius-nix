{
  config,
  pkgs,
  lib,
  namespace,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.${namespace}.packages.fonts;
in
{
  options.${namespace}.packages.fonts = {
    enable = mkEnableOption "fonts";
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        meslo-lgs-nf
        cascadia-code
        nerd-fonts.monaspace
        nerd-fonts.iosevka
        nerd-fonts.symbols-only
      ];
    };
  };
}

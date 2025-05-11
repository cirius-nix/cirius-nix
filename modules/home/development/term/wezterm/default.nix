{
  config,
  namespace,
  lib,
  ...
}:
let
  cfg = config.${namespace}.development.term.wezterm;
  inherit (lib) mkIf mkEnableOption;
  inherit (lib.${namespace}) mkStrOption;
in
{
  options.${namespace}.development.term.wezterm = {
    enable = mkEnableOption "Enable WezTerm";
    colorscheme = mkStrOption "" "Set colorscheme to use";
  };
  config = mkIf cfg.enable {
    programs.wezterm = {
      enable = true;
      extraConfig = ''
        return {
          color_scheme = "${cfg.colorscheme}";
        }
      '';
    };
  };
}

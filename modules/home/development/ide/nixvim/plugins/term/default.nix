{
  namespace,
  config,
  lib,
  ...
}:
let
  cfg = config.${namespace}.development.ide.nixvim.plugins.term;
  inherit (lib) mkIf mkEnableOption;
in
{
  options.${namespace}.development.ide.nixvim.plugins.term = {
    enable = mkEnableOption "Enable terminal in neovim";
  };

  config = mkIf cfg.enable {
    programs.nixvim.plugins = {
      toggleterm = {
        enable = true;
        settings = {
          direction = "float";
          float_opts = {
            border = "curved";
            height = 30;
            width = 130;
          };
          open_mapping = "[[<c-\\]]";
        };
      };
    };
  };
}

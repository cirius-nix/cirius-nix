# @Deprecated
{
  pkgs,
  config,
  namespace,
  lib,
  ...
}:
let
  inherit (lib) mkIf;
  cfg = config.${namespace}.development.ide.nixvim;
in
{
  config = mkIf cfg.enable {
    programs.nixvim = {

      extraPlugins = [
        pkgs.vimPlugins.fleet-theme-nvim
        pkgs.vimPlugins.cyberdream-nvim
        pkgs.vimPlugins.catppuccin-nvim
        pkgs.vimPlugins.github-nvim-theme
      ];
    };
  };
}

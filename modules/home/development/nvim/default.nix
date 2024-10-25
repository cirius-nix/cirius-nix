{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (builtins) attrValues;
  inherit (lib) mkEnableOption mkIf;
  inherit (pkgs) vimPlugins;

  cfg = config.cirius.development.nvim;

  pluginsWithConfiguration = {
    dracula-nvim = {
      plugin = vimPlugins.dracula-nvim;
      config = ''
        colorscheme dracula
        set termguicolors
      '';
    };
  };

in
# extraLuaConfig = builtins.readFile ./config.lua;
{
  options.cirius.development.nvim = {
    enable = mkEnableOption "Nvim";
  };

  config = mkIf cfg.enable {
    home.sessionVariables.MANPAGER = "nvim +Man!";

    programs.neovim = {
      inherit (cfg) enable;
      # inherit extraLuaConfig;

      defaultEditor = true;
      viAlias = true;
      vimAlias = true;

      plugins = attrValues {
        inherit (vimPlugins.nvim-treesitter) withAllGrammars;
        inherit (pluginsWithConfiguration) dracula-nvim;
      };
    };
  };
}

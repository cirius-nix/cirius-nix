{ config
, lib
, pkgs
, ...
}:

let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.cirius.development.nixvim;

  extraCfgLua = import ./nvim/extra-config.nix;
in
{
  options.cirius.development.nixvim = {
    enable = mkEnableOption "nixvim";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs;[ nodejs_22 ];
    programs.nixvim = {
      inherit (cfg) enable;
      colorschemes.vscode.enable = true;
      editorconfig = {
        enable = true;
      };
      plugins = import ./nvim/plugins.nix pkgs;
      opts = import ./nvim/options.nix;
      keymaps = import ./nvim/keymaps.nix;
      clipboard.register = "unnamedplus";
      globals = {
        mapleader = " ";
        maplocalleader = "\\";
        loaded_netrw = 1;
        loaded_netrwPlugin = 1;
      };
      extraPlugins = [
        (pkgs.vimUtils.buildVimPlugin {
          pname = "codecompanion";
          version = "v2.2.0";
          src = pkgs.fetchFromGitHub {
            owner = "olimorris";
            repo = "codecompanion.nvim";
            rev = "refs/tags/v2.2.0";
            hash = "sha256-VD3jI48H4n60aHzs8tf0FaZ+TRecjik78i71Yv+xVyY=";
          };
        })
      ];
      inherit (extraCfgLua) extraConfigLua;
      inherit (extraCfgLua) extraConfigLuaPre;
      inherit (extraCfgLua) extraConfigLuaPost;
    };
  };
}

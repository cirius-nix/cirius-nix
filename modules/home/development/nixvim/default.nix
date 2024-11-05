{
  config,
  lib,
  pkgs,
  ...
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
    home.packages = with pkgs; [ nodejs_22 ];
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
      inherit (extraCfgLua) extraConfigLua;
      inherit (extraCfgLua) extraConfigLuaPre;
      inherit (extraCfgLua) extraConfigLuaPost;
    };
  };
}

{
  config,
  lib,
  pkgs,
  ...
}@inputs:

let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.cirius.development.nixvim;

  extraCfgLua = import ./extra-config.nix;
in
{
  options.cirius.development.nixvim = {
    enable = mkEnableOption "nixvim";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ nodejs_22 ];
    programs.nixvim = {
      inherit (cfg) enable;
      colorschemes.ayu.enable = true;
      editorconfig = {
        enable = true;
      };
      plugins = import ./plugins.nix inputs;
      opts = import ./options.nix;
      keymaps = import ./keymaps.nix;
      clipboard.register = "unnamedplus";
      performance = {
        byteCompileLua = {
          enable = true;
          nvimRuntime = true;
          configs = true;
          plugins = true;
        };
      };
      globals = {
        mapleader = " ";
        maplocalleader = "\\";
        loaded_netrw = 1;
        loaded_netrwPlugin = 1;
      };
      extraPlugins = [
      ];
      inherit (extraCfgLua) extraConfigLua;
      inherit (extraCfgLua) extraConfigLuaPre;
      inherit (extraCfgLua) extraConfigLuaPost;
    };
  };
}

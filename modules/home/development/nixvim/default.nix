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
      colorschemes.vscode.enable = true;
      editorconfig = {
        enable = true;
      };
      plugins = import ./plugins.nix inputs;
      opts = import ./options.nix;
      keymaps = import ./keymaps.nix;
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
        # issue with hooks = { post_checkout = function() vim.cmd('make') end }
        # (pkgs.vimUtils.buildVimPlugin {
        #   pname = "avante.nvim";
        #   version = "latest";
        #   src = pkgs.fetchFromGitHub {
        #     owner = "yetone";
        #     repo = "avante.nvim";
        #     rev = "839a8ee25a84f813545440c4c798edd25bfd68a9";
        #     hash = "sha256-pWgJO4v6nUjO9rkTzPKO8pXNwAC372LE6cqv7P9Wfxg=";
        #   };
        # })
        (pkgs.vimUtils.buildVimPlugin {
          pname = "img-clip.nvim";
          version = "latest";
          src = pkgs.fetchFromGitHub {
            owner = "HakonHarnes";
            repo = "img-clip.nvim";
            rev = "28a32d811d69042f4fa5c3d5fa35571df2bc1623";
            hash = "sha256-TTfRow1rrRZ3+5YPeYAQc+2fsb42wUxTMEr6kfUiKXo=";
          };
        })
        (pkgs.vimUtils.buildVimPlugin {
          pname = "render-markdown.nvim";
          version = "latest";
          src = pkgs.fetchFromGitHub {
            owner = "MeanderingProgrammer";
            repo = "render-markdown.nvim";
            rev = "82184c4a3c3580a7a859b2cb7e58f16c10fd29ef";
            hash = "sha256-8xt2bjdNqMU3Um1mFDpUPEzQtUzwgBYv6nRw2tkKL8k=";
          };
        })
      ];
      inherit (extraCfgLua) extraConfigLua;
      inherit (extraCfgLua) extraConfigLuaPre;
      inherit (extraCfgLua) extraConfigLuaPost;
    };
  };
}

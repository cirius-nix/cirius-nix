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
        (pkgs.vimUtils.buildVimPlugin {
          pname = "go.nvim";
          version = "latest";
          src = pkgs.fetchFromGitHub {
            owner = "ray-x";
            repo = "go.nvim";
            rev = "6368756601a358b1491ac2ff10d0e2939a76df5e";
            hash = "sha256-dBpkzEGLjpwN5JZoV9QQbSQEkUszueopDvlwi7l3OXE=";
          };
        })
        (pkgs.vimUtils.buildVimPlugin {
          pname = "guihua.lua";
          version = "latest";
          src = pkgs.fetchFromGitHub {
            owner = "ray-x";
            repo = "guihua.lua";
            rev = "d783191eaa75215beae0c80319fcce5e6b3beeda";
            hash = "sha256-XpUsbj1boDfbyE8C6SdOvZdkd97682VVC81fvQ5WA/4";
          };
        })
      ];
      inherit (extraCfgLua) extraConfigLua;
      inherit (extraCfgLua) extraConfigLuaPre;
      inherit (extraCfgLua) extraConfigLuaPost;
    };
  };
}

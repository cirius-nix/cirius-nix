{
  config,
  lib,
  namespace,
  pkgs,
  ...
}:
let
  cfg = config.${namespace}.development.ide.nixvim;
  inherit (lib)
    mkEnableOption
    mkIf
    types
    ;

  inherit (lib.${namespace}) mkOpt;
in
{
  imports = lib.snowfall.fs.get-non-default-nix-files ./.;

  options.${namespace}.development.ide.nixvim = {
    enable = mkEnableOption "Enable NixVim or not";
    colorscheme = mkOpt types.str "gruvbox" "The colorscheme to use";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      nodejs_22 # dependencies
    ];
    programs.nixvim = {
      enable = true;
      colorschemes.vscode = {
        enable = true;
      };
      editorconfig.enable = true;
      clipboard.register = "unnamedplus";
      performance = {
        byteCompileLua = {
          enable = true;
          nvimRuntime = true;
          configs = true;
          plugins = true;
        };
      };
    };
  };
}

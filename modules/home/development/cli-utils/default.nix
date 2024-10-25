{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.cirius.development.cli-utils;
in
{
  options.cirius.development.cli-utils = {
    enable = mkEnableOption "CLI Utilities";
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        jq
        atuin
        fzf
        ripgrep
        tree-sitter
        unzip
        gcc
        gnumake
      ];

      sessionVariables = {
        "EDITOR" = "nvim";
      };
    };

    programs = {
      direnv = {
        inherit (cfg) enable;
        nix-direnv = {
          enable = true;
        };
      };
    };
  };
}

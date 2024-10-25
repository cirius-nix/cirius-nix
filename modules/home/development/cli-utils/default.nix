{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.cirius.development.cli;
in
{
  options.cirius.development.cli = {
    enable = mkEnableOption "CLI Utilities";
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        jq
        atuin
      ];

      programs = {
        direnv = {
          inherit (cfg) enable;
          nix-direnv = {
            enable = true;
          };
        };
      };

      sessionVariables = {
        "EDITOR" = "nvim";
      };
    };
  };
}

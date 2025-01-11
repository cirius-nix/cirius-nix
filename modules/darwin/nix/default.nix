{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.cirius.nix;
in
{
  options.cirius.nix = {
    enable = mkEnableOption "Nix";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      statix
      deadnix
      nixfmt-rfc-style
      nixpkgs-fmt
      nixd
      ps
    ];
  };
}

{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.${namespace}.nix;
in
{
  options.${namespace}.nix = {
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
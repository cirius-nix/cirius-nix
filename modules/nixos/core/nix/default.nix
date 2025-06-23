{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf mkOption;
  cfg = config.${namespace}.core.nix;
in
{
  options.${namespace}.core.nix = {
    enable = mkEnableOption "Nix";
    nixLd = {
      libraries = mkOption {
        type = lib.types.listOf lib.types.package;
        default = [ ];
        description = "Additional libraries to link against.";
      };
    };
  };

  config = mkIf cfg.enable {
    programs.nh = {
      enable = true;
    };
    programs.nix-ld = {
      enable = true;
      libraries =
        with pkgs;
        [
          gcc
          icu
          libcxx
          stdenv.cc.cc.lib
          zlib
        ]
        ++ (if cfg.nixLd.libraries != null then cfg.nixLd.libraries else [ ]);
    };
    environment.systemPackages = with pkgs; [
      statix
      deadnix
      nixfmt-rfc-style
      nixpkgs-fmt
      nixd
      nix-prefetch-github
    ];
    nix = {
      optimise.automatic = true;
      settings = {
        # auto-optimise-store = true; -- useful but slow.
        experimental-features = [
          "nix-command"
          "flakes"
        ];
      };
    };
  };
}

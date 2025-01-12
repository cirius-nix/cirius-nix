{
  inputs,
  lib,
  pkgs,
  system,
  namespace,
}:
let
  inherit (lib) mkShell;
  inherit (inputs) snowfall-flake;
in
mkShell {
  packages = with pkgs; [
    deadnix
    hydra-check
    nix-inspect
    nix-bisect
    nix-diff
    nix-health
    nix-index
    nix-melt
    nix-prefetch-git
    nix-search-cli
    nix-tree
    nix-update
    nixpkgs-hammering
    nixpkgs-lint
    nixpkgs-review
    snowfall-flake.packages.${system}.flake
    statix
  ];

  shellHooks = ''
    Welcome home! ${namespace}
  '';
}

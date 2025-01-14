{
  inputs,
  pkgs,
  system,
  namespace,
  mkShell,
}:
let
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
    nixd
    nixpkgs-hammering
    nixpkgs-lint
    nixpkgs-review
    statix
    snowfall-flake.packages.${system}.flake
  ];

  shellHooks = ''
    Welcome home! ${namespace}
  '';
}

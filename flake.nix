{
  description = "Cirius Nix";
  inputs = {
    zen-browser.url = "github:youwen5/zen-browser-flake";
    # optional, but recommended so it shares system libraries, and improves startup time
    zen-browser.inputs.nixpkgs.follows = "nixpkgs";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    pre-commit-hooks.url = "github:cachix/git-hooks.nix";
    nur.url = "github:nix-community/NUR";
    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    snowfall-flake = {
      url = "github:snowfallorg/flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
    };
    anyrun.url = "github:anyrun-org/anyrun";
    anyrun-nixos-options.url = "github:n3oney/anyrun-nixos-options";
    nix-your-shell = {
      url = "github:MercuryTechnologies/nix-your-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    let
      lib = inputs.snowfall-lib.mkLib {
        inherit inputs;
        src = ./.;
        snowfall = {
          meta = {
            name = "cirius-nix";
            title = "Cirius Nix Dotfiles";
          };
          namespace = "cirius";
        };
        # non standard pkgs
        perSystem =
          { system, ... }:
          {
            packages = {
              inherit (inputs.zen-browser.packages.${system}) default;
            };
          };
      };
    in
    lib.mkFlake {
      channels-config = {
        allowUnfree = true;
      };
      overlays = [ inputs.nur.overlays.default ];
      homes.modules = with inputs; [
        nixvim.homeManagerModules.nixvim
        inputs.anyrun.homeManagerModules.default
        inputs.nur.modules.homeManager.default
      ];
      systems.modules = {
        nixos = [
          inputs.sops-nix.nixosModules.sops
        ];
        darwin = [
          inputs.sops-nix.darwinModules.sops
        ];
      };
      outputs-builder = channels: { formatter = channels.nixpkgs.nixfmt-rfc-style; };
    };
}

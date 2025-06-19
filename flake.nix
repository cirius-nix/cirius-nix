{
  description = "Cirius Nix";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pre-commit-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
    anyrun = {
      url = "github:anyrun-org/anyrun";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    anyrun-nixos-options = {
      url = "github:n3oney/anyrun-nixos-options";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # secret manager.
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    catppuccin.url = "github:catppuccin/nix";
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
              # in system level configuration:
              # environment.systemPackages = [
              #   inputs.zen-browser.packages.${pkgs.system}.default
              # ];
            };
          };
      };
    in
    lib.mkFlake {
      channels-config = {
        allowUnfree = true;
      };
      # Add overlays for the `nixpkgs` channel.
      overlays = with inputs; [
        nix-vscode-extensions.overlays.default
      ];
      # system defined in systems/{arch}/{host}
      # systems/x86_84-linux/cirius
      # systems/aarch64-darwin/cirius
      systems.modules = {
        # add modules to all nixos system.
        nixos = with inputs; [
          sops-nix.nixosModules.sops
        ];
        # add modules to all darwin system.
        darwin = with inputs; [
          sops-nix.darwinModules.sops
        ];
      };
      # home defined in homes/{arch}/{username}@{host}
      homes = {
        # Add modules to all homes.
        modules = with inputs; [
          # nixvim editor
          nixvim.homeManagerModules.nixvim
          # secret management
          sops-nix.homeManagerModules.sops
          catppuccin.homeModules.catppuccin
        ];
      };
      outputs-builder = channels: { formatter = channels.nixpkgs.nixfmt-rfc-style; };
    };
}

{
  description = "Cirius Nix";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";

    pre-commit-hooks.url = "github:cachix/git-hooks.nix";

    nur.url = "github:nix-community/NUR";

    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
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

    hyprland = {
      url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
    hyprlock = {
      url = "github:hyprwm/Hyprlock";
      inputs.nixpkgs.follows = "hyprland/nixpkgs";
    };
    hyprpaper = {
      url = "github:hyprwm/hyprpaper";
      inputs.nixpkgs.follows = "hyprland/nixpkgs";
    };
    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "hyprland/nixpkgs";
    };
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    hypr-socket-watch = {
      url = "github:khaneliman/hypr-socket-watch";
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
      };
    in
    lib.mkFlake {
      channels-config = {
        allowUnfree = true;
      };

      overlays = [ inputs.nur.overlay ];

      homes.modules = with inputs; [
        nixvim.homeManagerModules.nixvim
      ];

      systems.modules.nixos = [ ];
      systems.modules.darwin = [ ];
    };
}

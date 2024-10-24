{
  description = "Cirius Nix";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";

    nur.url = "github:nix-community/NUR";

    darwin = {
      url = "github:lnl7/nix-darwin";
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

      systems.modules.nixos = [ inputs.home-manager.nixosModules.home-manager ];
    };
}

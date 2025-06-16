{
  description = "Golang monolith application";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
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
          root = ./nix;
          meta = {
            title = "Golang Monolith Application";
          };
          namespace = "golang-monolith-app";
        };
      };
    in
    lib.mkFlake {
      channels-config = {
        allowUnfree = false;
      };
      outputs-builder = channels: { formatter = channels.nixpkgs.nixfmt-rfc-style; };
    };
}

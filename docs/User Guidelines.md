# 🌀 Cirius Nix Dotfiles — User Guidelines

This project provides a structured Nix Flake template to manage your dotfiles
using nix-darwin, home-manager, and the modular Snowfall Flake ecosystem.

## 📦 What's Inside?

    ❄️ Nix Flake-compatible setup

    🐧 NixOS & 🍎 macOS (via nix-darwin) support

    🏡 Home Manager for user-level configurations

    🧩 Modular architecture using snowfall-flake and snowfall-lib

## 🚀 Getting Started

### Prerequisites

Make sure you have:

- Nix installed with flakes enabled

- macOS with nix-darwin (optional)

- Optional: Enable Home Manager

### Init project

References:

- [Snowfall Lib](https://snowfall.org/guides/lib/quickstart/)

```bash
# create project root
mkdir -p your_project_root 
cd your_project_root

# init nix
nix flake init
```

#### Structure

We will use this structure to manage configs between multiple users/machines

```
├── flake.nix                # The core flake logic
├── systems/                 # System-level configurations by arch/host
│   └── x86_64-linux/
│       └── cirius/
├── homes/                   # User-level configs by arch/user@host
│   └── aarch64-darwin/
│       └── username@cirius/
```

In there:

- The main different betweens `homes` and `systems` is:
  - `homes` and children modules in `modules/home` will be managed by
    `home-manager`. It follows home manager configuration so:
    - It has some same configs between `nixos` and `darwin`.
    - For config that only specific for `nixos` or `darwin` only, you can use
      `pkgs.stdenv.isLinux` or `pkgs.stdenv.isDarwin` to check before hand on.

      Example: `modules/home/packages/explorer/default.nix`
      ```nix
      { pkgs, namespace, lib, config, ... }:
      let
        inherit (lib) mkIf mkEnableOption;
        cfg = config.${namespace}.package.explorer;
      in
      {
        options.${namespace}.package.explorer = {
          enable = mkEnableOption "Enable Explorer Application";
        };
        config = mkIf cfg.enable {
          home.packages = [
            pkgs.yazi # shared between nixos & darwin
            (lib.optional pkgs.stdenv.isLinux pkgs.dolphin) # specific for nixos only.
          ];
        };
      }
      ```

- 🧑‍💻👨‍💻 `homes/{arch}/{user}@{host}` – **Per-user Configuration** Each user
  configuration is uniquely identified by a combination of:
  - arch – The architecture of the machine (e.g., x86_64-linux, aarch64-darwin)
  - user – The username on that machine
  - host – The hostname of the machine

  Example: I want to setup a Home Manager configuration for `Alice` on a Mac
  (ARM) named `macbook` and `Cirius` on a Linux machine named
  `local-nixos-machine`.

  Let create a `default.nix` configuration file under
  `homes/aarch64-darwin/alice@macbook/` and
  `homes/x86_64-linux/cirius@local-nixos-machine/`:

  ```
  homes/
  └── aarch64-darwin/                     # arch
      └── alice@macbook/                  # username@hostname
          └── default.nix                 # configuration
      x86_64-linux/                       # arch
      └── cirius@local-nixos-machine/     # username@hostname
          └── default.nix                 # configuration
  ```

  Inside each `default.nix` file, you can define the configuration for the user:

  ```nix
  {
    config,
    lib,
    pkgs,
    ...
  }: let 
    # namespace in this file is not passed to inputs. Then we must indicate
    # which namespace used here to config the module inside: systems/home
    namespace = "example";
  in {
    ${namespace} = {
      # The configuration of our modules will be defined here.
      # Our modules will be placed at: modules/home/submodules...
      # It will be explained in the next chapter
    };
  }
  ```

  The configuration here and modules in `systems/home` will be managed by
  `home-manager` and `snowfall-lib` inputs of `flake.nix`.

  This means:
  - You're setting up Home Manager for `alice` on a Mac (ARM) named `macbook`
    and `cirius` on Linux (x86_64) named `local-nixos-machine`.
  - You can have different configurations for the same user across devices, or
    different users on the same machine.

- 🖥️ `systems/{arch}/{host}` – **System-level Configuration** For full system
  configuration (NixOS or nix-darwin), the structure is:

  ```
  systems/
  └── aarch64-darwin/
      └── macbook/
          └── default.nix
      x86_84-linux/
      └── local-nixos-machine/
          └── default.nix
          └── hardware-configuration.nix
  ```

  - We config darwin system in `systems/aarch64-darwin/macbook/default.nix`:

    ```nix
    {
      # namespace defined in ${project_root}/flake.nix
      namespace,
      ...
    }:
    {
      ${namespace} = {
        # The configuration of our modules will be defined here.
        # Our modules will be placed at: modules/darwin/submodules...
        # It will be explained in the next chapter
      };

      # Enable nix-flake feature
      nix.settings.experimental-features = "nix-command flakes";

      # Let nix-darwin manages nix-daemon unconditionally when `nix.enable` is on.
      nix.enable = true;

      # other config here...

      # your stateVersion placed here.
      system.stateVersion = 5;
    }
    ```

  - We config linux system in
    `systems/x86_84-linux/local-nixos-machine/default.nix` and
    `systems/x86_84-linux/local-nixos-machine/hardware-configuration.nix`:

    For `hardware-configuration.nix`, you must copy the content of
    `/etc/nixos/hardware-configuration.nix` to it. We will use the generated
    hardware config from nixos.

    For `default.nix`:
    ```nix
    {
      namespace,
      ...
    }:
    {
      # import hardware configuration to this file.
      imports = [ ./hardware-configuration.nix ];

      ${namespace} = {
        # The configuration of our modules will be defined here.
        # Our modules will be placed at: modules/nixos/submodules...
        # It will be explained in the next chapter
      };

      # Auto optimize store of nix.
      nix.settings.auto-optimise-store = true;
      # Allow unfree applications, services,...
      nixpkgs.config.allowUnfree = true;

      # other config here...

      # state version
      system.stateVersion = "24.05";
    }
    ```

  This means:

  - You're managing 2 system configurations:
    - For a mac machine with architecture `aarch64-darwin` and hostname
      `macbook`.
    - For a linux machine with architecture `x86_64-linux` and hostname
      `local-nixos-machine`.
  - Inside each `default.nix`, the `${namespace} = {}` part is using config from
    `modules/{systemType}`. Darwin will be `modules/darwin`, linux will be
    `modules/nixos`. It will not be mixed between 2 systems.

  NOTE:

  Because you will use this project to manage dotfiles of entire systems, you
  should move config from `/etc/nix-darwin` `/etc/nixos` to
  `systems/{arch}/{host}/default.nix`. After that, you can rebuild your system
  in this project by:

  ```bash
  # Darwin
  sudo darwin-rebuild switch --flake .#<hostname>

  # Linux
  sudo nixos-rebuild switch --flake .#<hostname>
  ```

The last thing, create a `flake.nix` file to manage defined config under this
project. Using `snowfall-lib`, it will automatically import & use config from
`systems`, `homes`, `modules`, `libs`,... which is under current src `./.`. Here
is an example of new `flake.nix`:

```nix
{
  description = "Example Nix Flake";

  # Inputs prepare the inputs to be passed to outputs function.
  # Each param in input must follow a structured to provide: config, pkgs,
  # lib,... Which will be used inside outputs function.
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
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
  };

  # Outputs returns a function like:
  # const flakeFn = (args: Inputs): Outputs => {...} # In TS
  outputs =
    inputs:
    let
      lib = inputs.snowfall-lib.mkLib {
        inherit inputs;
        src = ./.;
        snowfall = {
          meta = {
            name = "example-nix";
            title = "Example Nix Dotfiles";
          };
          # used to prevent the collisions between
          # config of user and the other sources
          namespace = "example"; 

        };
        # non standard pkgs
        perSystem =
          { system, ... }:
          {
            packages = {
              # inherit (inputs.zen-browser.packages.${system}) default;
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
      overlays = [ ];
      # system defined in systems/{arch}/{host}
      # systems/x86_84-linux/example-local-machine
      # systems/aarch64-darwin/example-macbook-m2-pro
      systems.modules = {
        # add modules to all nixos system.
        nixos = with inputs; [
        ];
        # add modules to all darwin system.
        darwin = with inputs; [
        ];
      };
      # home defined in homes/{arch}/{username}@{host}
      # homes/aarch64-darwin/example@example-macbook-m2-pro
      homes = {
        # Add modules to all homes.
        modules = with inputs; [
        ];
      };
      outputs-builder = channels: { formatter = channels.nixpkgs.nixfmt-rfc-style; };
    };
}
```

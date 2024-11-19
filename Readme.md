<div align="center">

# Cirius Nix

Cirius Nix is my personal dotfiles. Managed by Nix + Snowfall lib ❄️<br>
Packages are always in stable status. No cheating, no workaround to provide the best user experiment.

</div>

## Roadmap

My configuration is still in development state. Here is the roadmap of my progress:

- [x] Support multiple architectures. With [Snowfall](https://snowfall.org) powered, It's done.
- [x] Config NixVim to make it as default code editor:
    - [] Config debuggers
    - [] Config testing adapters
    - [x] Intergrate with LSPs
    - [x] Added some tinker plugins
- [] Implement SOPS nix to manage secrets.
- [] CI with cachix to reduce time and resource to build artifacts on local machine.
- [] Update structure & usage for this project.

## Intro

My nix configuration offers:<br>
- Supported MacOS / NixOS. For MacOS, seamlessly integrated and managed Nix through [Nix-Darwin](https://github.com/LnL7/nix-darwin).
- Configured Nixvim with required plugins for development.
- Secrets will be managed by [SOPS](https://github.com/Mic92/sops-nix) by default.
- Supported Templates & Devshells to manage needed packages + package's versions for earch projects.
- Configured fish shell with awesome development features.

## Structure

The structure is followed [Snowfall Lib](https://github.com/snowfallorg/lib).<br>
Updating...

## How to use

Before using this configuration, you should read the section below to
understand the structure and how to use it to manage your environment.

NOTE:
- Some packages are built for specific architecture.
- Different machine used NixOS will require different hardware configuration. (You can see it in `/etc/nixos/configuration.nix` & `/etc/nixos/hardware-configuration.nix`)

### NixOS / Linux based

Updating...

### MacOS based

Updating...

### Building script + aliases

Updating...

### Templates & Devshells

Updating...

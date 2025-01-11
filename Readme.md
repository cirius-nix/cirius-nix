<div align="center">

# Cirius Nix (24.11 Beta)

Cirius Nix is my personal dotfiles. Managed by Nix + Snowfall lib ❄️<br>
Packages are always in stable status. No cheating, no workaround to provide the
best user experiment.

</div>

## Roadmap

<b>IMPORTANT!!! Line with `(Beta Feature)` will be removed when closing the beta
version and merging to stable branch. New feature will be developed in beta
branch from 2024-11-19 10:00AM VNT</b>

My configuration is still in development state. Here is the roadmap of my
progress:

- [x] Support multiple architectures. With [Snowfall](https://snowfall.org)
      powered, it's done.
  - [ ] Config KDE + Hyprland for linux users.
    - [x] KDE
    - [ ] Hyprland
- [x] Config NixVim to make it as default code editor:
  - [x] Temporally config Nixvim with latest packages while waiting for NixVim
        24.11 release. `(Beta Feature)`
  - [ ] Config debuggers
  - [ ] Config testing adapters
  - [x] Intergrate with LSPs
  - [x] Added some tinker plugins
- [ ] Implement SOPS nix to manage secrets.
- [ ] CI with cachix to reduce time and resource to build artifacts on local
      machine.
- [ ] Update structure & usage for this project.

## Tasks of current branch

- [x] System: Upgrade version from 24.05 to 24.11
- [x] NixVim: Remove `none-ls` by another plugins to handle `code-action`,
      `diagnostics`, `formatting` and `hover`.
  - [x] Use `Conform` to be `formatter`.
  - [ ] Use ... to diagnostic code.
  - [ ] Use ... as `code-action` provider.
  - [ ] Use .... as `hover` provider.
- [ ] NixVim: Build testing, debugging adapters.
- [ ] NixVim: Update layout to adapt with `Snowfall` structure.
- [ ] NixVim: Migrate keybinding declarations to new `which-key` behavior.
- [ ] NixVim: Use `Avante` as AI helper.

## Intro

My nix configuration offers:<br>

- Supported MacOS / NixOS. For MacOS, seamlessly integrated and managed Nix by
  [Nix-Darwin](https://github.com/LnL7/nix-darwin).
- Configured Nixvim with required plugins for development.
- Secrets will be managed by [SOPS](https://github.com/Mic92/sops-nix) by
  default.
- Supported Templates & Devshells to manage needed packages + package's versions
  for earch projects.
- Configured fish shell with awesome development features.

## Structure

The structure is followed
[Snowfall Lib](https://github.com/snowfallorg/lib).<br> Updating...

## How to use

Before using this configuration, you should read the section below to understand
the structure and how to use it to manage your environment.

NOTE:

- Some packages are built for specific architecture.
- Different machine used NixOS will require different hardware configuration.
  (You can see it in `/etc/nixos/configuration.nix` &
  `/etc/nixos/hardware-configuration.nix`)

### NixOS / Linux based

Updating...

### MacOS based

Updating...

### Building script + aliases

Updating...

### Templates & Devshells

Updating...

<div align="center">

# Cirius Nix (24.11 Beta)

Cirius Nix is my personal dotfiles. Managed by Nix + Snowfall lib ❄️<br>
Packages are always in stable status. No cheating, no workaround to provide the
best user experiment.

</div>

## Roadmap

My configuration is still in development state. Here is the roadmap of my
progress:

- [x] Support multiple architectures. With [Snowfall](https://snowfall.org)
      powered, it's done.
  - [x] Config KDE + Hyprland for linux users.
    - [x] KDE
    - [x] Hyprland
- [x] Config NixVim to make it as default code editor:
  - [x] Temporally config Nixvim with latest packages while waiting for NixVim
        24.11 release. `(Beta Feature)`
  - [x] Config debuggers
  - [x] Config testing adapters
  - [x] Intergrate with LSPs
  - [x] Added some tinker plugins
- [x] Update structure & usage for this project.

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

## Structure & Usage

The structure is followed
[Snowfall Lib](https://github.com/snowfallorg/lib).<br>

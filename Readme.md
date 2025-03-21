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

## Tasks of current branch

- [x] System: Upgrade version from 24.05 to 24.11
- [x] NixVim: Remove `none-ls` by another plugins to handle `code-action`,
      `diagnostics`, `formatting` and `hover`.
- [x] NixVim: Build testing, debugging adapters.
- [x] NixVim: Update layout to adapt with `Snowfall` structure.
- [x] NixVim: Migrate keybinding declarations to new `which-key` behavior.
- [x] NixVim: Use `Avante` as AI helper.

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

### Useful snippets

- Check current env is `linux`:

```nix
pkgs.stdenv.isLinux
```

### NixOS / Linux based

Updating...

### MacOS based

Updating...

### Building script + aliases

Updating...

### Templates & Devshells

Updating...

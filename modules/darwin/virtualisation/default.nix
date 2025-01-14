{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.core.virtualisation;

  # Work around https://github.com/containers/podman/issues/17026
  # by downgrading to qemu-8.1.3.
  inherit
    (import (pkgs.fetchFromGitHub {
      owner = "NixOS";
      repo = "nixpkgs";
      rev = "4db6d0ab3a62ea7149386a40eb23d1bd4f508e6e";
      sha256 = "sha256-kyw7744auSe+BdkLwFGyGbOHqxdE3p2hO6cw7KRLflw=";
    }) { inherit (pkgs) system; })
    qemu
    ;
in
{
  options.${namespace}.core.virtualisation = {
    enable = mkEnableOption "Virtualisation";
  };

  config = mkIf cfg.enable {
    # dependencies
    # environment.systemPackages = with pkgs; [
    #   docker
    #   arion # Docker compose? use nix instead: arion-compose.nix
    #   dive # Tool for exploring each layer in a docker image
    #   podman
    #   lazydocker
    #   podman-compose
    #   qemu
    #   xz
    # ];
    #
    # environment.pathsToLink = [ "/share/qemu" ];
    #
    # environment.etc."containers/containers.conf.d/99-gvproxy-path.conf".text = ''
    #   [engine]
    #   helper_binaries_dir = ["${pkgs.gvproxy}/bin"]
    # '';

    # NOTE:
    # systemd services is not available in macOS
    # handy workaround
    #
    # In the first time.
    #   podman machine init
    # The machine needs to be started after init, and again on each boot.
    #   podman machine start
    # This machine is currently configured in rootless mode. If your containers
    # require root permissions (e.g. ports < 1024), or if you run into compatibility
    # issues with non-podman clients, you can switch using the following command:
    # 	podman machine set --rootful

    # NOTE: no virtualisation options for macOS
    # these options are for Linux:
    # // mkIf pkgs.stdenv.isLinux {
    #   virtualisation = {
    #     podman = {
    #       enable = true;
    #       dockerSocket.enable = true;
    #       dockerCompat = true;
    #       defaultNetwork.settings.dns_enabled = true;
    #       autoPrune.dates = "weekly";
    #       autoPrune.flags = [ "--all" ];
    #       enableNvidia = true;
    #     };
    #   };
    # }
  };
}

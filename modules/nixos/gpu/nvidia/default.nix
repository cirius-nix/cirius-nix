{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkDefault mkEnableOption mkIf;
  inherit (pkgs.nvidia) nvidiaPackage;

  cfg = config.cirius.nvidia;
in
{
  options.cirius.nvidia = {
    enable = mkEnableOption "nvidia";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      nvfancontrol

      nvtopPackages.nvidia

      # mesa
      mesa

      # vulkan
      vulkan-tools
      vulkan-loader
      vulkan-validation-layers
      vulkan-extension-layer
    ];

    services.xserver.videoDrivers = [ "nvidia" ];
    boot.blacklistedKernelModules = [ "nouveau" ];
    hardware = {
      graphics = {
        enable = true;
        extraPackages = with pkgs; [ nvidia-vaapi-driver ];
        extraPackages32 = with pkgs.pkgsi686Linux; [ nvidia-vaapi-driver ];
      };

      nvidia = {
        package = mkDefault nvidiaPackage;
        modesetting.enable = true;

        powerManagement = {
          # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
          # Enable this if you have graphical corruption issues or application crashes after waking
          # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
          # of just the bare essentials.
          enable = true;
          # Fine-grained power management. Turns off GPU when not in use.
          # Experimental and only works on modern Nvidia GPUs (Turing or newer).
          finegrained = false;
        };

        # Use the NVidia open source kernel module (not to be confused with the
        # independent third-party "nouveau" open source driver).
        # Support is limited to the Turing and later architectures. Full list of 
        # supported GPUs is at: 
        # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
        # Only available from driver 515.43.04+
        # Currently alpha-quality/buggy, so false is currently the recommended setting.
        open = false;
        # Enable the Nvidia settings menu,
        # accessible via `nvidia-settings`.
        nvidiaSettings = false;
        nvidiaPersistenced = true;
        forceFullCompositionPipeline = true;
      };
    };
  };
}

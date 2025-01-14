{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.cpu-utils.amd;
in
{
  options.${namespace}.cpu-utils.amd = {
    enable = mkBoolOpt false "Whether or not to enable support for amd cpu.";
    extraUdevRules = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      description = ''
        Extra udev rules for amd cpu.
      '';
      example = ''
        {
          "DeepCool-AG400" = '''';
        };
      '';
    };
  };

  config = mkIf cfg.enable {
    boot = {
      extraModulePackages = mkIf (pkgs ? zenpower) [ config.boot.kernelPackages.zenpower ];

      kernelModules = [
        "kvm-amd" # amd virtualization
        "amd-pstate" # load pstate module in case the device has a newer gpu
        "zenpower" # zenpower is for reading cpu info, i.e voltage
        "msr" # x86 CPU MSR access device
      ];

      kernelParams = [ "amd_pstate=active" ];
    };

    services.udev.extraRules =
      ''
        # AMD CPU
        SUBSYSTEM=="cpu", ACTION=="add", ENV{CPU}=="?", RUN+="${pkgs.amdctl}/bin/amdctl --set-all=performance"
      ''
      + lib.concatStringsSep "\n" (map (rule: rule) (builtins.attrValues cfg.extraUdevRules));

    # core package & dependencies
    environment.systemPackages = [
      pkgs.amdctl
      pkgs.usbutils
      pkgs.busybox
    ];
    hardware.cpu.amd.updateMicrocode = true;
  };
}

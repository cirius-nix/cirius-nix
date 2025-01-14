{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.core.ssh;
in
{
  options.${namespace}.core.ssh = {
    enable = mkEnableOption "SSH";
  };

  config = mkIf cfg.enable { programs.ssh.startAgent = true; };
}

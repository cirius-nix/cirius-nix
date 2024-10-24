{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.cirius.ssh;
in
{
  options.cirius.ssh = {
    enable = mkEnableOption "SSH";
  };

  config = mkIf cfg.enable { programs.ssh.startAgent = true; };
}

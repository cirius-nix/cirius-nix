{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt mkStrOption;

  cfg = config.${namespace}.applications.looking-glass;
in
{
  options.${namespace}.applications.looking-glass = {
    enable = mkBoolOpt false "Whether or not to enable the Looking Glass client.";
    user = mkStrOption null "The user to run looking-glass as.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      looking-glass-client
    ];

    environment.etc."looking-glass-client.ini" = {
      user = "+${toString config.users.users.${cfg.user}.uid}";
      source = ./client.ini;
    };

    systemd.tmpfiles.settings = {
      "looking-glass" = {
        "/dev/shm/looking-glass".f = {
          age = "-";
          group = "kvm";
          mode = "0660";
          user = toString config.users.users.${cfg.user}.uid;
        };
      };
    };
  };
}

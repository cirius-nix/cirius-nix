{
  config,
  pkgs,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) types mkIf mkEnableOption;
  inherit (lib.${namespace}) mkListOption mkStrOption;
  cfg = config.${namespace}.packages.security;
in
{
  options = {
    ${namespace}.packages.security = {
      enable = mkEnableOption "Enable security options";
      secretFile = mkStrOption "" "SOPS ENCRYPTED SECRETS FILE";
      sshKeyPaths = mkListOption types.str [ ] "SSH key paths";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      sops
      age
      ssh-to-age
    ];

    ${namespace}.development.cli-utils.fish = {
      interactiveEnvs = {
        "SOPS_AGE_KEY_FILE" = "~/.config/sops/age/keys.txt";
      };
    };

    sops = {
      defaultSopsFile = cfg.secretFile;
      defaultSopsFormat = "yaml";
      age = {
        generateKey = true;
        keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
        sshKeyPaths = [ "${config.home.homeDirectory}/.ssh/id_ed25519" ] ++ cfg.sshKeyPaths;
      };
    };
  };
}

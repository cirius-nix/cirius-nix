{
  config,
  pkgs,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) types;
  inherit (lib.${namespace}) mkListOption mkPathOption;
  cfg = config.${namespace}.packages.security;
  userCfg = config.${namespace}.user;
in
{
  options = {
    ${namespace}.packages.security = {
      secretFile = mkPathOption ../../../../secrets/${userCfg.username}/default.yaml "SOPS ENCRYPTED SECRETS FILE";
      sshKeyPaths = mkListOption types.str [ ] "SSH key paths";
    };
  };

  config = {
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
      secrets = { };
    };
  };
}

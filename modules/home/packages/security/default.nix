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
      secretFile = mkStrOption "" "SOPS ENCRYPTED SECRET FILE";
      sshKeyPaths = mkListOption types.str [ ] "SSH key paths";
    };
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      sops
      age
      ssh-to-age
    ];

    sops = {
      defaultSopsFile = cfg.secretFile;
      defaultSopsFormat = "yaml";
      age = {
        generateKey = true;
        keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
        sshKeyPaths = [ "${config.home.homeDirectory}/.ssh/id_ed25519" ] ++ cfg.sshKeyPaths;
      };
      # %r gets replaced with a runtime directory, use %% to specify a '%'
      # sign. Runtime dir is $XDG_RUNTIME_DIR on linux and $(getconf
      # DARWIN_USER_TEMP_DIR) on darwin.
      # secrets."example_key" = {
      #   # YAML, JSON, INI, dotenv
      #   format = "dotenv";
      #   path = "%r/secrets/cirius-darwin/default.yaml";
      # };
    };
  };
}

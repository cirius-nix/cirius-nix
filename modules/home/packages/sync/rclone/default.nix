{
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.packages.sync.rclone;
  inherit (lib) mkIf mkEnableOption;
  inherit (lib.${namespace}) mkStrOption ifAllNotZero mergeL';

  ggdriveSecret = {
    inherit (cfg.ggdrive.sops.keys) clientId clientSecret;
    enable = ifAllNotZero [
      cfg.ggdrive.sops.enable
      ggdriveSecret.clientId
      ggdriveSecret.clientSecret
    ];
  };
in
{
  options.${namespace}.packages.sync.rclone = {
    enable = mkEnableOption "Enable RClone";
    ggdrive = {
      enable = mkEnableOption "Enable Default Google Drive Remote";
      sops = {
        enable = mkEnableOption "Enable SOPS";
        keys = {
          clientId = mkStrOption "rclone_ggdrive_client_id" "Name of client ID secret";
          clientSecret = mkStrOption "rclone_ggdrive_client_secret" "Name of client secret secret";
        };
      };
    };
  };

  config = mkIf cfg.enable {
    sops = {
      secrets = mergeL' { } [
        (mkIf ggdriveSecret.enable {
          ${ggdriveSecret.clientId} = {
            mode = "0440";
          };
          ${ggdriveSecret.clientSecret} = {
            mode = "0440";
          };
        })
      ];
    };
    programs.rclone = {
      enable = true;
      remotes = {
        "ggdrive-default" = mkIf cfg.ggdrive.enable {
          type = "drive";
          secrets = mkIf ggdriveSecret.enable {
            client_id = config.sops.secrets.${ggdriveSecret.clientId}.path;
            client_secret = config.sops.secrets.${ggdriveSecret.clientSecret}.path;
          };
        };
      };
    };
  };
}

{
  config,
  pkgs,
  namespace,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (config.${namespace}.development.cli-utils) amz-q;
in
{
  options.${namespace}.development.cli-utils.amz-q.enable = mkEnableOption "Enable amz-q";
  config = mkIf (amz-q.enable && pkgs.stdenv.isLinux) {
    home.packages = with pkgs; [
      amazon-q-cli
    ];
  };
}

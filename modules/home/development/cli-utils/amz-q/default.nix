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
  inherit (config.${namespace}.development.ide) vscode;
in
{
  options.${namespace}.development.cli-utils.amz-q = {
    enable = mkEnableOption "Enable amz-q";
    vscodeIntegration = {
      enable = mkEnableOption "Enable VSCode integration";
    };
  };
  config = mkIf (amz-q.enable) {
    home.packages = mkIf pkgs.stdenv.isLinux (
      with pkgs;
      [
        amazon-q-cli
      ]
    );
    programs.vscode = mkIf (vscode.enable && amz-q.vscodeIntegration.enable) {
      profiles.default.extensions = with pkgs; [
        vscode-extensions.amazonwebservices.amazon-q-vscode
      ];
    };
  };
}

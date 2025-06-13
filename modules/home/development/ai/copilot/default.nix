{
  config,
  namespace,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (config.${namespace}.development.ai) copilot;
in
{
  options.${namespace}.development.ai.copilot = {
    enable = mkEnableOption "Enable copilot";
  };

  config = mkIf copilot.enable {
    programs.vscode.profiles.default.extensions = with pkgs.vscode-extensions; [
      github.copilot
    ];
  };
}

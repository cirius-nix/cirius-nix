{
  config,
  namespace,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (config.${namespace}.development.ai) aider;
in
{
  options.${namespace}.development.ai.aider = {
    enable = mkEnableOption "Enable Aider";
  };

  config = mkIf aider.enable {
    home.packages = [
      pkgs.aider-chat-full
    ];
  };
}

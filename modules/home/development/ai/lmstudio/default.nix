{
  config,
  namespace,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (config.${namespace}.development.ai) lmstudio;
in
{
  options.${namespace}.development.ai.lmstudio = {
    enable = mkEnableOption "Enable LM Studio";
  };

  config = mkIf lmstudio.enable {
    home.packages = [
      pkgs.lmstudio
    ];
  };
}

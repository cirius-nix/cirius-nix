{
  config,
  namespace,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  inherit (config.${namespace}.development.infra) docker;
  inherit (config.${namespace}.development.cli-utils) fish;
in
{
  options.${namespace}.development.infra.docker = {
    enable = mkEnableOption "Enable docker";
    enableFishIntegration = mkEnableOption "Enable fish shell integration";
  };

  config = mkIf docker.enable {
    ${namespace}.development.cli-utils.fish = mkIf (fish.enable && docker.enableFishIntegration) {
      aliases = {
        "lzdock" = "lazydocker";
      };
    };

    programs.lazydocker = {
      enable = true;
      settings = { };
    };
  };
}

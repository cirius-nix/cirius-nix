{
  config,
  namespace,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption;
  inherit (config.${namespace}.development.cli-utils) btop;
in
{
  options.${namespace}.development.cli-utils.btop = {
    enable = mkEnableOption "btop";
  };

  config = lib.mkIf btop.enable {
    programs.btop = {
      enable = true;
      settings = { };
    };
  };
}

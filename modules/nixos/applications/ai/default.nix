{
  config,
  namespace,
  lib,
  ...
}:
let
  cfg = config.${namespace}.applications.ai;
in
{
  options.${namespace}.applications.ai = {
    enable = lib.mkEnableOption "Toggle AI";
  };

  config = lib.mkIf cfg.enable {
    services.ollama = {
      enable = true;
      port = 11000;
      acceleration = "cuda";
    };
  };
}

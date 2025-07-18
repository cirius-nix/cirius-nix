{
  config,
  namespace,
  lib,
  osConfig,
  pkgs,
  ...
}:
let
  isLinux = pkgs.stdenv.isLinux;
  isDarwin = pkgs.stdenv.isDarwin;

  cfg = config.${namespace}.development.ai;
  osCfg = osConfig.${namespace}.applications.ai;

  inherit (lib.${namespace}) mkIntOption;
  port = if isLinux then osCfg.port else cfg.port;
  defaultOllamaPort = 11000;
in
{
  options.${namespace}.development.ai = {
    enable = lib.mkEnableOption "Toggle AI Development Tools (Tabby, Aider, etc.)";
    port = mkIntOption defaultOllamaPort "Ollama Service Port (used on macOS if enabled here)";
  };

  config = lib.mkIf cfg.enable {
    home = {
      packages =
        with pkgs;
        lib.flatten [
          [
            katana
          ]
          (lib.optional isLinux [
            python313
            python313Packages.peft
            # broken build
            python313Packages.transformers
            python313Packages.bitsandbytes
          ])
        ];
    };

    services = lib.mkIf isDarwin {
      ollama = {
        enable = true;
        port = port;
        acceleration = null;
      };
    };
  };
}

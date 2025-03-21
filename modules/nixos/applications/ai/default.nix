{
  config,
  namespace,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.${namespace}.applications.ai;
  inherit (lib.${namespace}) mkIntOption;

  gpuCfg = config.${namespace}.gpu-drivers;
  acceleration = if gpuCfg.nvidia.enable then "cuda" else null;
in
{
  options.${namespace}.applications.ai = {
    enable = lib.mkEnableOption "Toggle AI";
    port = mkIntOption 11000 "Port to use ollama";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      cmake
      llama-cpp
    ];
    services = {
      nextjs-ollama-llm-ui = {
        enable = true;
        port = 11002;
        ollamaUrl = "http://127.0.0.1:${builtins.toString cfg.port}";
        hostname = "127.0.0.1";
      };
      ollama = {
        enable = true;
        port = cfg.port;
        acceleration = acceleration;
      };
    };
  };
}

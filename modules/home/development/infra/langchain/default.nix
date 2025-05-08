{
  pkgs,
  config,
  namespace,
  lib,
  ...
}:
let
  cfg = config.${namespace}.development.infra.langchain;
  inherit (pkgs.stdenv) isLinux isDarwin;
  inherit (lib) mkIf mkEnableOption;
  inherit (lib.${namespace}) mkStrOption mkIntOption;

  chromaPath =
    if cfg.chroma.path != "" then
      cfg.chroma.path
    else
      config.${namespace}.user.homeDir + "/.config/chroma/chroma_data";
in
{
  options.${namespace}.development.infra.langchain = {
    enable = mkEnableOption "Enable LangChain";
    chroma = {
      path = mkStrOption "" "Path to store chroma db";
      port = mkIntOption 11010 "port of chroma server";
    };
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      python312Packages.gradio
      python312Packages.chromadb
      python312Packages.langchain
      python312Packages.langchain-community
      python312Packages.langchain-aws
      python312Packages.langchain-openai
      python312Packages.langchain-ollama
      python312Packages.langchain-chroma
    ];

    xdg.configFile."chroma/config".text = ''
      path=${chromaPath}
      host=localhost
      port=${builtins.toString cfg.chroma.port}
    '';

    systemd.user.services.langchain-chroma = mkIf isLinux {
      Unit = {
        Description = "User-level chromadb for langchain";
        After = [ "ollama.service" ];
      };
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.python312Packages.chromadb}/bin/chroma run --path ${chromaPath} --host localhost --port ${builtins.toString cfg.chroma.port}";
        Restart = "on-failure";
        RestartSec = "5s";
      };
      Install.WantedBy = [ "default.target" ];
    };

    launchd.agents.langchain-chroma = mkIf isDarwin {
      enable = true;
      config = {
        Label = "com.langchain-chroma.serve";
        # TODO: make exec start command
        ProgramArguments = [
        ];
        RunAtLoad = true;
        KeepAlive = true;
        StandardOutPath = "/tmp/langchain-chroma-${config.${namespace}.user.name}.log";
        StandardErrorPath = "/tmp/langchain-chroma-${config.${namespace}.user.name}.err";
      };
    };
  };
}

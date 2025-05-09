{
  namespace,
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.${namespace}.development.ide.vscode.continue;

  inherit (lib.${namespace}) mkStrOption mkEnumOption mkListOption;

  modelType = lib.types.submodule {
    options = {
      title = mkStrOption "" "Title of model";
      provider = mkEnumOption [
        "ollama"
      ] "ollama" "Provider";
      model = mkStrOption "" "Model";
      apiBase = mkStrOption "" "Server api endpoint";
    };
  };
in
{
  options.${namespace}.development.ide.vscode.continue = {
    enable = lib.mkEnableOption "Enable continue plugin";
    chatModels = mkListOption modelType [ ] "List of models";
    autoCompleteModel = lib.mkOption {
      type = lib.null or modelType;
      description = "Auto complete model";
    };
    embeddingModel = lib.mkOption {
      type = lib.null or modelType;
      description = "Embedding model";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.vscode = {
      profiles.default.extensions = with pkgs.vscode-extensions; [
        continue.continue
      ];
    };
    sops.templates = {
      ".continue_vscode_ai" = {
        mode = "0440";
        path = "${config.${namespace}.user.homeDir}/.continue/config.json";
        content = builtins.toJSON {
          models = cfg.chatModels;
          tabAutocompleteModel = cfg.autoCompleteModel;
          embeddingsProvider = cfg.embeddingModel;
          contextProviders = [
            {
              name = "code";
              params = { };
            }
            {
              name = "docs";
              params = { };
            }
            {
              name = "diff";
              params = { };
            }
            {
              name = "terminal";
              params = { };
            }
            {
              name = "problems";
              params = { };
            }
            {
              name = "folder";
              params = { };
            }
            {
              name = "codebase";
              params = { };
            }
          ];
          slashCommands = [
            {
              name = "share";
              description = "Export the current chat session to markdown";
            }
            {
              name = "cmd";
              description = "Generate a shell command";
            }
            {
              name = "commit";
              description = "Generate a git commit message";
            }
          ];
          data = [ ];
        };
      };
    };
  };
}

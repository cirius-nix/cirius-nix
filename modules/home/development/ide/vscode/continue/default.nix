{
  namespace,
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkIf
    types
    mkEnableOption
    mkOption
    optionalAttrs
    ;
  inherit (lib.${namespace}) mkStrOption mkEnumOption mkListOption;
  inherit (types) nullOr;

  continue = config.${namespace}.development.ide.vscode.continue;

  modelType = lib.types.submodule {
    options = {
      title = mkStrOption "" "Title of model";
      provider = mkEnumOption [
        "mistral"
        "openai" # deepinfra also use openai as provider.
        "ollama"
      ] "ollama" "Provider";
      model = mkStrOption "" "Model";
      apiBase = mkStrOption "" "Server api endpoint";
      apiKey = mkStrOption "" "API Key";
    };
  };
in
{
  options.${namespace}.development.ide.vscode.continue = {
    enable = mkEnableOption "Enable continue plugin";
    chatModels = mkListOption modelType [ ] "List of models";
    autoCompleteModel = mkOption {
      type = nullOr modelType;
      default = null;
      description = "Auto complete model";
    };
    embeddingModel = mkOption {
      type = nullOr modelType;
      default = null;
      description = "Embedding model";
    };
  };

  config = mkIf continue.enable {
    programs.vscode = {
      profiles.default.extensions = [
        pkgs.vscode-extensions.continue.continue
      ];
    };
    sops.templates = {
      ".continue_vscode_ai" = {
        mode = "0440";
        path = "${config.${namespace}.user.homeDir}/.continue/config.json";
        content = builtins.toJSON (
          {
            models = continue.chatModels;
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
          }
          // optionalAttrs (continue.embeddingModel != null && continue.embeddingModel.model != "") {
            embeddingsProvider = continue.embeddingModel;
          }
          // optionalAttrs (continue.autoCompleteModel != null && continue.autoCompleteModel.model != "") {
            tabAutocompleteModel = continue.autoCompleteModel or { };
          }
        );
      };
    };
  };
}

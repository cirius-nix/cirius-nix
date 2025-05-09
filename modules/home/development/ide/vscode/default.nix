{
  namespace,
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.${namespace}.development.ide.vscode;
  inherit (lib) mkIf mkEnableOption;
in
{
  options.${namespace}.development.ide.vscode = {
    enable = mkEnableOption "VSCode development environment";
    enableDockerExts = mkEnableOption "Enable Docker extensions";
    enableExtendedExts = mkEnableOption "Enable extended extensions";
    # TODO: integrate with nixvim
    enableVimExt = mkEnableOption "Enable Vim extensions";
  };
  config = mkIf cfg.enable {
    programs.vscode = {
      enable = true;
      mutableExtensionsDir = false;
      userSettings = {
        "workbench.iconTheme" = "catppuccin-mocha";
        "workbench.colorTheme" = "Catppuccin Mocha";
        "editor.fontLigatures" = true;
        "git.enableCommitSigning" = false;
        "git.confirmSync" = false;
        "files.autoSave" = "afterDelay";
        "files.autoSaveDelay" = 100;
        "editor.wordWrap" = "bounded";
        "editor.wordWrapColumn" = 100;
        "[markdown]" = {
          "editor.wordWrap" = "bounded";
        };
      };
      profiles.default = {
        enableExtensionUpdateCheck = false;
        enableUpdateCheck = false;
        extensions = lib.concatLists [
          (lib.optionals cfg.enableDockerExts (
            with pkgs.vscode-extensions;
            [
              ms-azuretools.vscode-docker
              ms-vscode-remote.remote-containers
            ]
          ))

          (lib.optionals cfg.enableExtendedExts (
            with pkgs.vscode-extensions;
            [
              aaron-bond.better-comments
              editorconfig.editorconfig
              pkief.material-icon-theme
              gruntfuggly.todo-tree
              catppuccin.catppuccin-vsc
              catppuccin.catppuccin-vsc-icons
              shd101wyy.markdown-preview-enhanced
              yzhang.markdown-all-in-one
            ]
          ))

          (lib.optionals cfg.enableVimExt (
            with pkgs.vscode-extensions;
            [
              vscodevim.vim
            ]
          ))
        ];
      };
    };
  };
}

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
  inherit (lib.${namespace}) mkListOption;
in
{
  options.${namespace}.development.ide.vscode = {
    enable = mkEnableOption "VSCode development environment";
    addPlugins = mkListOption lib.types.package [ ] "Additional packages";
    enableDockerExts = mkEnableOption "Enable Docker extensions";
    enableExtendedExts = mkEnableOption "Enable extended extensions";
    # TODO: integrate with nixvim
    enableVimExt = mkEnableOption "Enable Vim extensions";
  };
  config = mkIf cfg.enable {
    home.packages = lib.concatLists [
      [
        pkgs.vscode
      ]

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
}

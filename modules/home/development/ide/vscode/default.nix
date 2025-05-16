{
  namespace,
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (lib.${namespace}) mergeL';

  cfg = config.${namespace}.development.ide.vscode;

  inherit
    (import ../keybindings.nix {
      inherit lib namespace;
    })
    common
    searching
    ;

  vimModeKeyBindings = mergeL' { } [
    common.vscode
    searching.vscode
  ];
  vimModeExternalKeyBindings = lib.concatLists [
    searching.vscodeExternal
  ];
in
{
  options.${namespace}.development.ide.vscode = {
    enable = mkEnableOption "VSCode development environment";
    exts = {
      docker = mkEnableOption "Enable Docker extensions";
      extended = mkEnableOption "Enable extended extensions";
      vim = mkEnableOption "Enable Vim extensions";
    };
    enableFishIntegration = mkEnableOption "Enable fish shell integration";
    projectRoots = lib.${namespace}.mkListOption lib.types.str [ ] "List of project roots";
  };
  config = mkIf cfg.enable {
    programs.vscode = {
      enable = true;
      mutableExtensionsDir = false;
      profiles.default = {
        userSettings =
          {
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
            # TODO: move this to development AI.
            "github.copilot.enable" = {
              "*" = false;
              "plaintext" = false;
              "markdown" = false;
              "scminput" = false;
            };
          }
          // (lib.optionals cfg.enableFishIntegration {
            "terminal.integrated.defaultProfile.osx" = "fish";
            "terminal.integrated.defaultProfile.linux" = "fish";
          })
          // (lib.optionals cfg.exts.extended {
            "projectManager.git.baseFolders" = cfg.projectRoots;
          })
          // (
            lib.optionals cfg.exts.vim {
              "vim.enableNeovim" = true;
              "vim.neovimPath" = "${pkgs.neovim}/bin/nvim";
              "vim.neovimUseConfigFile" = true;
              "vim.neovimConfigPath" = "~/.config/nvim/init.lua";
              "vim.highlightedyank.enable" = true;
              "vim.hlsearch" = true;
              "vim.useSystemClipboard" = true;
            }
            // vimModeKeyBindings
          );
        keybindings = lib.concatLists [
          (lib.optionals cfg.exts.vim vimModeExternalKeyBindings)
        ];
        enableExtensionUpdateCheck = false;
        enableUpdateCheck = false;
        extensions = lib.concatLists [
          (lib.optionals cfg.exts.docker (
            with pkgs.vscode-extensions;
            [
              ms-azuretools.vscode-docker
              ms-vscode-remote.remote-containers
            ]
          ))

          (lib.optionals cfg.exts.extended (
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
              alefragnani.project-manager
            ]
          ))

          (lib.optionals cfg.exts.vim (
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

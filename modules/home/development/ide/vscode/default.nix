{
  namespace,
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (lib.${namespace}) deepMergeL' mkStrOption;

  cfg = config.${namespace}.development.ide.vscode;

  inherit
    (import ../keybindings.nix {
      inherit lib namespace;
    })
    common
    searching
    wincmd
    ;

  vimModeKeyBindings = deepMergeL' { } [
    common.vscode
    searching.vscode
    wincmd.vscode
  ];
  vimModeExternalKeyBindings = lib.concatLists [
    common.vscodeExternal
    searching.vscodeExternal
    wincmd.vscodeExternal
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
    gitcommit = {
      instructionPrompt = mkStrOption "Follow the Conventional Commits format strictly for commit messages. Use the structure below:\n\n```\n<type>[optional scope]: <gitmoji> <description>\n\n[optional body]\n```\n\nGuidelines:\n\n1. **Type and Scope**: Choose an appropriate type (e.g., `feat`, `fix`) and optional scope to describe the affected module or feature.\n\n2. **Gitmoji**: Include a relevant `gitmoji` that best represents the nature of the change.\n\n3. **Description**: Write a concise, informative description in the header; use backticks if referencing code or specific terms.\n\n4. **Body**: For additional details, use a well-structured body section:\n   - Use bullet points (`*`) for clarity.\n   - Clearly describe the motivation, context, or technical details behind the change, if applicable.\n\nCommit messages should be clear, informative, and professional, aiding readability and project tracking." "Instruction prompt to generate AI commit message. Thanks: https://gist.github.com/okineadev/8a3f392a93ae50e8d523e4ba7f9f9ac3";
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
            "editor.fontFamily" = "Cascadia Mono NF, 'Droid Sans Mono', 'monospace', monospace";
            "[markdown]" = {
              "editor.wordWrap" = "bounded";
            };
            "editor.formatOnSave" = true;
            "github.copilot.enable" = {
              "*" = false;
              "plaintext" = false;
              "markdown" = false;
              "scminput" = false;
            };
            "github.copilot.chat.commitMessageGeneration.instructions" = [
              {
                "text" = cfg.gitcommit.instructionPrompt;
              }
            ];
            "workbench.sideBar.location" = "left";
            "workbench.secondarySideBar.showLabels" = true;
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

# VSCode Development Environment Module

This Nix module configures a highly customizable VSCode-based development
environment.

## 📦 Module Options

Under the path: `.${namespace}.development.ide.vscode`

| Option                        | Type            | Description                                                       |
| ----------------------------- | --------------- | ----------------------------------------------------------------- |
| `enable`                      | bool            | Enable the VSCode development environment.                        |
| `exts.docker`                 | bool            | Enable Docker-related extensions.                                 |
| `exts.extended`               | bool            | Enable a curated list of popular and useful extensions.           |
| `exts.vim`                    | bool            | Enable Vim support and Neovim integration in VSCode.              |
| `enableFishIntegration`       | bool            | Set `fish` as the default terminal profile on macOS.              |
| `projectRoots`                | list of strings | A list of project root folders for the Project Manager extension. |
| `gitcommit.instructionPrompt` | string          | Instruction prompt for AI to generate commit message.             |

📝 Sample Usage in Nix Flake

```nix
{
  ${namespace}.development.ide.vscode = {
    enable = true;
    exts = {
      vim = true;
      docker = true;
      extended = true;
    };
    enableFishIntegration = true;
    projectRoots = [ "/home/user/projects" ];
  };
}
```

---

## ⚙️ VSCode Configuration

This module sets the following in `programs.vscode`:

- Enables VSCode.
- Disables extension directory mutation.
- Sets various editor and Git settings.
- Enables `fish` terminal integration (optional).
- Enables Vim mode with full Neovim integration (optional).
- Custom keybindings from shared configuration (optional).
- Adds a curated list of extensions based on enabled options.

---

## 🧩 Included Extensions

### 🔧 Docker Extensions (if `enableDockerExts` is enabled)

| Extension Name                       | Description                               |
| ------------------------------------ | ----------------------------------------- |
| `ms-azuretools.vscode-docker`        | Official Docker extension from Microsoft. |
| `ms-vscode-remote.remote-containers` | Support for developing inside containers. |

### 🌟 Extended Useful Extensions (if `enableExtendedExts` is enabled)

| Extension Name                        | Description                                                    |
| ------------------------------------- | -------------------------------------------------------------- |
| `aaron-bond.better-comments`          | Enhance code readability with color-coded comments.            |
| `editorconfig.editorconfig`           | EditorConfig support for maintaining consistent coding styles. |
| `pkief.material-icon-theme`           | Material design icons for VSCode.                              |
| `gruntfuggly.todo-tree`               | Highlight and list all TODOs, FIXMEs, etc. in your project.    |
| `shd101wyy.markdown-preview-enhanced` | Advanced Markdown preview capabilities.                        |
| `yzhang.markdown-all-in-one`          | Markdown editing enhancements.                                 |
| `alefragnani.project-manager`         | Project Manager for quickly switching projects.                |

### 🧘 Vim Extensions (if `enableVimExt` is enabled)

| Extension Name  | Description                                      |
| --------------- | ------------------------------------------------ |
| `vscodevim.vim` | Vim emulation inside VSCode with Neovim support. |

---

## 🗝️ Keybindings

- Custom keybindings for Vim and search functions are merged from the shared
  `keybindings.nix`.
- Additional keybindings are included if `enableVimExt` is enabled.

---

## 🐚 Terminal Integration

- If `enableFishIntegration = true`, sets `fish` as the default terminal profile
  on macOS:
  ```json
  "terminal.integrated.defaultProfile.osx": "fish"
  "terminal.integrated.defaultProfile.linux": "fish"
  ```

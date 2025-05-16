{ lib, namespace, ... }:
let
  inherit (lib.${namespace}.nixvim) mkKeymap;
in
{
  common = {
    vscode = {
      "vim.leader" = "<space>";
      "vim.normalModeKeyBindings" = [
        {
          before = [
            "<leader>"
            ":"
          ];
          commands = [ "workbench.action.showCommands" ];
        }
        {
          before = [
            "<leader>"
            "q"
          ];
          commands = [ ":xa" ];
        }
        {
          before = [ "<ESC>" ];
          commands = [ ":nohl" ];
        }
      ];
      "vim.visualModeKeyBindings" = [
        {
          before = [ ">" ];
          commands = [ "editor.action.indentLines" ];
        }
        {
          before = [ "<" ];
          commands = [ "editor.action.outdentLines" ];
        }
      ];
      "vim.visualModeKeyBindingsNonRecursive" = [
        # paste without overwriting current register
        {
          before = [ "p" ];
          after = [
            "p"
            "g"
            "v"
            "y"
          ];
        }
      ];
      "vim.insertModeKeyBindings" = [
        {
          before = [
            "j"
            "k"
          ];
          after = [ "<ESC>" ];
        }
        {
          before = [
            "j"
            "j"
          ];
          after = [ "<ESC>" ];
        }
      ];
      "vim.handleKeys" = {
        "<C-a>" = false;
        "<C-f>" = false;
      };
    };
    nixvim = [
      {
        action = "<cmd>xa<cr>";
        key = "<leader>q";
        mode = "n";
        options = {
          silent = true;
          nowait = true;
          desc = "󰸧 Save and close";
        };
      }
      {
        action = "<cmd>nohlsearch<cr>";
        key = "<esc>";
        mode = "n";
        options = {
          silent = true;
          nowait = true;
        };
      }
      {
        mode = "i";
        key = "jk";
        action = "<esc>";
        options = {
          silent = true;
          nowait = true;
          desc = "Escape";
        };
      }
      {
        mode = "i";
        key = "jj";
        action = "<esc>";
        options = {
          silent = true;
          nowait = true;
          desc = "Escape";
        };
      }
    ];
  };
  wincmd = {
    vscode = [ ];
    nixvim = [
      {
        action = "<cmd>wincmd h<cr>";
        key = "<leader>wh";
        mode = "n";
        options = {
          silent = true;
          desc = " Move To Left";
        };
      }
      {
        action = "<cmd>wincmd j<cr>";
        key = "<leader>wj";
        mode = "n";
        options = {
          silent = true;
          desc = " Move To Down";
        };
      }
      {
        action = "<cmd>wincmd k<cr>";
        key = "<leader>wk";
        mode = "n";
        options = {
          silent = true;
          desc = " Move to Up";
        };
      }
      {
        action = "<cmd>wincmd l<cr>";
        key = "<leader>wl";
        mode = "n";
        options = {
          silent = true;
          desc = " Move To Right";
        };
      }
    ];
  };
  searching = {
    vscode = {
      "vim.normalModeKeyBindingsNonRecursive" = [
        {
          before = [
            "<leader>"
            "e"
          ];
          commands = [ "workbench.view.explorer" ];
        }
      ];
      "vim.normalModeKeyBindings" = [
        {
          before = [
            "<leader>"
            "f"
            "f"
          ];
          commands = [ "workbench.action.quickOpen" ];
          when = [ "!editorFocus" ];
        }
      ];
    };
    vscodeExternal = [
      {
        key = "space f f"; # chores
        command = "workbench.action.quickOpen";
        when = "!editorTextFocus && !inputFocus && !inQuickOpen";
      }
      {
        key = "cmd+p";
        command = "-workbench.action.quickOpen";
      }
      {
        key = "ctrl+p";
        command = "-workbench.action.quickOpen";
      }
      {
        key = "Tab";
        command = "quickInput.next";
        when = "inQuickInput && quickInputType == 'quickPick'";
      }
      {
        key = "space e";
        command = "workbench.view.explorer";
        when = "!editorTextFocus && !inputFocus && viewContainer.workbench.view.explorer.enabled";
      }
      {
        key = "shift+cmd+e";
        command = "-workbench.view.explorer";
        when = "viewContainer.workbench.view.explorer.enabled";
      }
      {
        key = "h";
        command = "previousCompressedFolder";
        when = "explorerViewletCompressedFocus && filesExplorerFocus && foldersViewVisible && !explorerViewletCompressedFirstFocus && !inputFocus";
      }
      {
        key = "l";
        command = "nextCompressedFolder";
        when = "explorerViewletCompressedFocus && filesExplorerFocus && foldersViewVisible && !explorerViewletCompressedLastFocus && !inputFocus";
      }
      {
        key = "a";
        command = "explorer.newFile";
        when = "explorerViewletFocus && !inputFocus && viewContainer.workbench.view.explorer.enabled";
      }
      {
        key = "ctrl+v";
        command = "runCommands";
        args = {
          commands = [
            "explorer.openToSide"
          ];
        };
        when = "explorerViewletFocus && foldersViewVisible && !inputFocus";
      }
      {
        key = "ctrl+enter";
        command = "-explorer.openToSide";
        when = "explorerViewletFocus && foldersViewVisible && !inputFocus";
      }
      {
        key = "ctrl+enter";
        command = "-explorer.openToSide";
        when = "explorerViewletFocus && foldersViewVisible && !inputFocus";
      }
    ];
    nixvim = [
      # NvimTree
      (mkKeymap "<leader>e" "<cmd>lua _G.FUNCS.neotree_focus_or_close()<cr>" "󰙅 Toggle Explorer")
      # Spectre
      (mkKeymap "<leader>s" "<cmd>lua require('spectre').toggle()<cr>" " Search & Replace")
      (mkKeymap "<leader>s" "<cmd>lua require('spectre').open_visual()<cr>" {
        mode = [ "v" ];
        options = {
          silent = true;
          noremap = true;
          nowait = true;
          desc = " Search & Replace";
        };
      })
      # Telescope
      (mkKeymap "<leader>ff" "<cmd>Telescope find_files<cr>" " Find File")
      # live grep fs
      (mkKeymap "<leader>fs" "<cmd>Telescope live_grep<cr>" "󱄽 Search String")
      # live grep fs in visual mode
      (mkKeymap "<leader>fs" "<cmd>lua _G.FUNCS.search_selected_text_in_visual_mode()<cr>" {
        mode = [ "v" ];
        options = {
          silent = true;
          noremap = true;
          nowait = true;
          desc = "󱄽 Search String";
        };
      })
      # buffers fb
      (mkKeymap "<leader>fb" "<cmd>Telescope buffers<cr>" " Buffers")
      # resume fr
      (mkKeymap "<leader>fr" "<cmd>Telescope resume<cr>" " Resume")
      # help help
      (mkKeymap "<leader>fh" "<cmd>Telescope help_tags<cr>" "󰘥 Help")
      # TodoTrouble ft
      (mkKeymap "<leader>ft" "<cmd>TodoTrouble<cr>" " TODO")
      (mkKeymap "<leader>fi" "<cmd>Telescope nerdy<cr>" "󰲍 Icon picker")
    ];
  };
}

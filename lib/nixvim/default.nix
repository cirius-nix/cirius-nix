{ ... }:
{
  # This file defines helper functions for configuring NixVim.
  # These functions simplify common tasks like enabling/disabling features,
  # creating paths, and defining key mappings.
  nixvim = {
    # `mkPath`: Creates a Nix path from a string.
    # Useful for referencing files or directories in NixVim configurations.
    mkPath =
      pathStr:
      (builtins.path {
        path = pathStr;
      });

    # `mkEnabled`: Returns an attribute set with `enable = true`.
    # Used to enable features in NixVim configurations.
    mkEnabled = {
      enable = true;
    };

    # `mkDisabled`: Returns an attribute set with `enable = false`.
    # Used to disable features in NixVim configurations.
    mkDisabled = {
      enable = false;
    };

    # `mkRaw`: Wraps raw content in an attribute set with `__raw`.
    # Used to pass raw Lua or Vimscript code directly to NixVim.
    mkRaw = rawContent: {
      __raw = rawContent;
    };

    # `mkKeymap`: Creates a key mapping for NixVim.
    # Parameters:
    # - `key`: The key combination (e.g., "<leader>ff").
    # - `action`: The action to perform (e.g., a Lua function or command).
    # - `opts`: Optional settings for the keymap (e.g., description, mode).
    mkKeymap =
      key: action: opts:
      let
        # Default keymap options:
        # - `nowait`: Don't wait for additional key presses.
        # - `noremap`: Disable recursive mapping.
        # - `silent`: Suppress command output.
        defaultOptions = {
          nowait = true;
          noremap = true;
          silent = true;
        };

        # Merge user-provided options with defaults.
        options =
          if opts == null then
            defaultOptions
          else if builtins.isString opts then
            defaultOptions // { desc = opts; } # If `opts` is a string, treat it as a description.
          else if builtins.isAttrs opts && opts ? options then
            opts.options # If `opts` has an `options` field, use it.
          else
            defaultOptions;

        # Determine the mode(s) for the keymap (default: normal mode "n").
        mode =
          if builtins.isAttrs opts && opts ? mode && builtins.isList opts.mode then opts.mode else [ "n" ];
      in
      {
        mode = mode;
        key = key;
        action = action;
        options = options;
      };
  };
}

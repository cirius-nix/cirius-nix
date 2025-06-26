{
  lib,
  namespace,
  config,
  ...
}:
let
  cfg = config.${namespace}.development.ide.nixvim.plugins.completion;
in
{
  options = {
    ${namespace}.development.ide.nixvim.plugins.completion = {
      tabAutocompleteSources = lib.${namespace}.mkListOption lib.types.str [ ] "TabAutoComplete Source";
    };
  };
  config = {
    programs.nixvim.plugins = {
      blink-compat = {
        enable = true;
        settings = {
          debug = true;
          impersonate_nvim_cmp = true;
        };
      };
      blink-cmp-spell.enable = true;
      blink-cmp-dictionary.enable = true;
      blink-cmp = {
        enable = true;
        settings = {
          keymap = {
            preset = "super-tab";
            "<cr>" = [
              "select_and_accept"
              "fallback"
            ];
            "<Tab>" = [
              "snippet_forward"
              "select_next"
              "fallback"
            ];
            "<S-Tab>" = [
              "snippet_backward"
              "select_prev"
              "fallback"
            ];
          };
          sources = {
            default = lib.concatLists [
              cfg.tabAutocompleteSources
              [
                "lsp"
                "path"
                "snippets"
                "buffer"
              ]
            ];
          };
          cmdline = {
            enabled = true;
            keymap = {
              preset = "cmdline";
            };
            sources = [
              "cmdline"
            ];
          };
          completion = {
            trigger = { };
            list = {
              selection = {
                preselect = true;
                auto_insert = true;
              };
            };
            keyword = {
              range = "full";
            };
            ghost_text.enabled = true;
          };
          snippets = { };
          signature = {
            enabled = true;
          };
        };
      };
    };
  };
}

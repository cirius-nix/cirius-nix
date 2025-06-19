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
      };
      blink-cmp = {
        enable = true;
        settings = {
          keymap = {
            preset = "super-tab";
            "<cr>" = [
              "select_and_accept"
              "fallback"
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

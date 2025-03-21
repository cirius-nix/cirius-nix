{
  lib,
  namespace,
  config,
  ...
}:
let
  cfg = config.${namespace}.development.ide.nixvim.plugins.completion;
  inherit (lib.${namespace}.nixvim) mkRaw;
in
{
  options = {
    ${namespace}.development.ide.nixvim.plugins.completion = {
      tabAutocompleteSources = lib.${namespace}.mkListOption (lib.types.submodule {
        options = {
          name = lib.${namespace}.mkStrOption null "Name of source";
        };
      }) [ ] "TabAutoComplete Source";
    };
  };
  config = {
    programs.nixvim.plugins = {
      cmp = {
        enable = true;
        autoEnableSources = true;
        cmdline = {
          "/" = {
            mapping = mkRaw "cmp.mapping.preset.cmdline()";
            sources = [ { name = "buffer"; } ];
          };
          ":" = {
            mapping = mkRaw "cmp.mapping.preset.cmdline()";
            sources = [
              { name = "path"; }
              {
                name = "cmdline";
                option = {
                  ignore_cmds = [
                    "Man"
                    "!"
                  ];
                };
              }
            ];
          };
        };
        settings = {
          preselect = "cmp.PreselectMode.Item";
          mapping = {
            "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
            "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
            "<C-e>" = "cmp.mapping.abort()";
            "<CR>" = "cmp.mapping.confirm({ select = true })";
          };
          sources = lib.concatLists [
            cfg.tabAutocompleteSources
            [
              { name = "nvim_lsp"; }
              { name = "cmp_tabby"; }
              { name = "treesitter"; }
              {
                name = "buffer";
                option.get_bufnrs = mkRaw "vim.api.nvim_list_bufs";
              }
              { name = "path"; }
            ]
          ];
        };
      };
    };
  };
}

{
  config,
  namespace,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.${namespace}.nixvim) mkKeymap mkEnabled mkRaw;
  cfg = config.${namespace}.development.ide.nixvim.plugins.testing;
in
{
  options.${namespace}.development.ide.nixvim.plugins.testing = {
    enable = mkEnableOption "Enable Testing Plugins";

  };
  config = mkIf cfg.enable {
    programs.nixvim = {
      plugins = mkIf cfg.enable {
        coverage = mkEnabled;
        neotest = {
          enable = true;
          adapters.go = {
            enable = true;
            settings = {
              args = mkRaw ''
                {
                  "-v",
                  "-race",
                  "-coverprofile=" .. vim.fn.getcwd() .. "/coverage.out",
                }
              '';
            };
          };
          settings = { };
        };
      };
      keymaps = [
        # RunFile tr
        (mkKeymap "<leader>tr" "<cmd>Neotest run file<cr>" "RunFile")
        # Runlast tl
        (mkKeymap "<leader>tl" "<cmd>Neotest run last<cr>" "Runlast")
        # Coverage tc
        (mkKeymap "<leader>tc" "<cmd>Coverage<cr>" "Coverage")
        # CoverageSummary tC
        (mkKeymap "<leader>tC" "<cmd>CoverageSummary<cr>" "CoverageSummary")
        # TestSummary tt
        (mkKeymap "<leader>tt" "<cmd>Neotest summary toggle<cr>" "TestSummary")
        # TestOutput to
        (mkKeymap "<leader>to" "<cmd>Neotest output-panel toggle<cr>" "TestOutput")
      ];
    };
  };
}

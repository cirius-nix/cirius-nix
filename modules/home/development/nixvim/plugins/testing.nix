{
  neotest = {
    enable = true;
    adapters.go = {
      enable = true;
      settings = {
        args = {
          __raw = ''
            {
              "-v",
              "-race",
              "-coverprofile=" .. vim.fn.getcwd() .. "/coverage.out",
            }
          '';
        };
      };
    };
    settings = { };
  };
  coverage = {
    enable = true;
  };
}

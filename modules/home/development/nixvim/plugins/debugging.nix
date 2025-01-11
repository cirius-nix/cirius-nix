{
  dap = {
    enable = true;
    adapters = {
      servers = { };
    };
    configurations = {
      go = [ ];
    };
    extensions = {
      dap-go = {
        enable = true;
      };
      dap-ui = {
        enable = true;
      };
      dap-virtual-text.enable = true;
    };
  };
}

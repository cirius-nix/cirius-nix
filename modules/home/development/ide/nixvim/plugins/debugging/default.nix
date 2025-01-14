{
  namespace,
  lib,
  config,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    mkOption
    types
    ;
  cfg = config.${namespace}.development.ide.nixvim.plugins.debugging;
in
{
  options.${namespace}.development.ide.nixvim.plugins.debugging = {
    enable = mkEnableOption "Enable debugging plugins";
  };

  config = mkIf cfg.enable {
    programs.nixvim.plugins = {
      cmp-dap = {
        enable = true;
      };
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
    };
  };
}

{
  config,
  namespace,
  lib,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (config.${namespace}.development.ide) nixvim;
  # inherit (nixvim) lsp;
in
{
  options.${namespace}.development.ide.nixvim.lsp = {
  };

  config = mkIf nixvim.enable {
    programs.nixvim.lsp = {
      keymaps = [
        {
          key = "K";
          lspBufAction = "hover";
        }
      ];
    };
  };
}

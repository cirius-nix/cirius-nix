{
  namespace,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (lib.${namespace}.nixvim) mkEnabled;
  cfg = config.${namespace}.development.ide.nixvim.plugins.languages.terraform;
in
{
  options.${namespace}.development.ide.nixvim.plugins.languages.terraform = {
    enable = mkEnableOption "Terraform Language Server";
  };
  config = mkIf cfg.enable {
    programs.nixvim.plugins = {
      lsp.servers = {
        terraformls = mkEnabled;
      };
      conform-nvim.settings = {
        # INFO: custom formatter to be used.
        formatters = {
          terraform_fmt = {
            command = lib.getExe pkgs.terraform;
          };
        };

        # INFO: use formatter(s).
        formatters_by_ft = {
          terraform = [ "terraform_fmt" ];
        };
      };
    };
  };
}

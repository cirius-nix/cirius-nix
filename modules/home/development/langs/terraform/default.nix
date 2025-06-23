{
  namespace,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (config.${namespace}.development.langs) terraform;
in
{
  options.${namespace}.development.langs.terraform = {
    enable = mkEnableOption "Terraform Language Server";
  };
  config = mkIf terraform.enable {
    programs.nixvim.lsp.servers = {
      terraformls.enable = true;
    };
    programs.nixvim.plugins = {
      conform-nvim.settings = {
        formatters = {
          terraform_fmt = {
            command = lib.getExe pkgs.terraform;
          };
        };
        formatters_by_ft = {
          terraform = [ "terraform_fmt" ];
        };
      };
    };
  };
}

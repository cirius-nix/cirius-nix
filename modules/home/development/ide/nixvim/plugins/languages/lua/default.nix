{
  namespace,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    ;

  inherit (lib.${namespace}.nixvim) mkEnabled;

  cfg = config.${namespace}.development.ide.nixvim.plugins.languages.lua;
in
{
  options.${namespace}.development.ide.nixvim.plugins.languages.lua = {
    enable = mkEnableOption "Enable Lua Language Server";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      lua
      stylua
    ];
    programs.nixvim.plugins = {
      lsp.servers = {
        lua_ls = mkEnabled;
      };
      conform-nvim.settings = {
        # INFO: custom formatter to be used.
        formatters = {
          stylua = {
            command = lib.getExe pkgs.stylua;
          };
        };

        # INFO: use formatter(s).
        formatters_by_ft = {
          lua = [ "stylua" ];
        };
      };
    };
  };
}

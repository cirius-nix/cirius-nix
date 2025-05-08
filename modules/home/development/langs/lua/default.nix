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

  cfg = config.${namespace}.development.langs.lua;
in
{
  options.${namespace}.development.langs.lua = {
    enable = mkEnableOption "Enable Lua Language Server";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      lua
      stylua
    ];
    programs.nixvim.plugins = {
      lsp.servers = {
        lua_ls.enable = true;
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

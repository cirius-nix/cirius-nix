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
    getExe
    ;

  inherit (config.${namespace}.development.langs) lua;
in
{
  options.${namespace}.development.langs.lua = {
    enable = mkEnableOption "Enable Lua Language Server";
  };

  config = mkIf lua.enable {
    home.packages = with pkgs; [
      stylua
    ];
    programs.nixvim = {
      lsp.servers = {
        lua_ls.enable = true;
      };
    };
    programs.nixvim.plugins = {
      conform-nvim.settings = {
        formatters = {
          stylua = {
            command = getExe pkgs.stylua;
          };
        };
        formatters_by_ft = {
          lua = [ "stylua" ];
        };
      };
    };
  };
}

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
    mkOption
    types
    ;

  cfg = config.${namespace}.development.ide.nixvim.plugins.languages.go;

  rayxgoModuleType = types.submodule (
    { config, ... }:
    {
      options = {
        enable = mkEnableOption "Enable go.nvim";
        configPre = mkOption {
          type = types.str;
          default = "";
        };
        config = mkOption {
          type = types.str;
          default = ''
            require('go').setup({})
          '';
        };
        configPost = mkOption {
          type = types.str;
          default = "";
        };
      };
    }
  );

in
{
  options.${namespace}.development.ide.nixvim.plugins.languages.go = {
    enable = mkEnableOption "Enable Go support";
    use3rdPlugins = mkOption {
      type = types.submodule {
        options = {
          rayxgo = mkOption {
            type = rayxgoModuleType;
            default = { };
            description = "Configuration for go.nvim";
          };
        };
      };
    };
  };

  config = mkIf cfg.enable {
    programs.nixvim = {
      plugins.lsp.servers = {
        gopls.enable = true;
      };
      extraPlugins = mkIf cfg.use3rdPlugins.rayxgo.enable [
        (pkgs.vimUtils.buildVimPlugin {
          pname = "go.nvim";
          version = "latest";
          src = pkgs.fetchFromGitHub {
            owner = "ray-x";
            repo = "go.nvim";
            rev = "a9efe436c5294fa24098e81859755ec755a94a60";
            hash = "sha256-t/pJ1KrVlVC3T9kzHij5O/Yem25vtvHGpYbOK0cRN9Q=";
          };
        })
      ];
    };
  };
}

{
  config,
  namespace,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.${namespace}.development.ide.nixvim.plugins.languages.nix;
in
{
  options.${namespace}.development.ide.nixvim.plugins.languages.nix = {
    enable = lib.mkEnableOption "Enable Nix language support";
  };

  config = lib.mkIf (cfg.enable) {
    programs.nixvim = {
      plugins = {
        direnv.enable = true;
        nix.enable = true;
        nix-develop = {
          enable = true;
        };
        lsp = {
          servers = {
            nixd.enable = true;
            nil_ls = {
              enable = true;
              settings = {
                formatting = {
                  command = [ "${lib.getExe pkgs.nixfmt-rfc-style}" ];
                };
                nix = {
                  flake = {
                    autoArchive = true;
                  };
                };
              };
            };
          };
        };
      };

    };
  };
}

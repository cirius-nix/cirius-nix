{
  config,
  lib,
  namespace,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.${namespace}.development.langs.nix;
in
{
  options.${namespace}.development.langs.nix = {
    enable = mkEnableOption "Nix Language";
  };

  config = mkIf cfg.enable {
    ${namespace} = {
      development.ide.nixvim.plugins = {
        languages.nix = {
          enable = true;
        };
      };
    };
  };
}

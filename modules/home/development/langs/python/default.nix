{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.${namespace}.development.langs.python;
in
{
  options.${namespace}.development.langs.python = {
    enable = mkEnableOption "Enable python language";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
    ];

    programs.nixvim = {
      plugins = {
        lsp.servers = {

        };

        conform-nvim.settings = {
          formatters = {
            # pythonimports = {
            #   command = "${pkgs.pythontools}/bin/goimports";
            # };
            # pythonimports-reviser = {
            #   command = lib.getExe pkgs.pythonimports-reviser;
            # };
          };

          formatters_by_ft = {
            # python = [
            #   "pythonimports"
            #   "pythonimports-reviser"
            # ];
          };
        };
      };
    };

    ${namespace}.development.ide.vscode.addPlugins = with pkgs.vscode-extensions; [
      ms-python.python
      ms-python.debugpy
    ];
  };
}

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
      python311Packages.black
    ];

    programs.nixvim = {
      plugins = {
        lsp.servers = {
          pylsp.enable = true;
        };

        conform-nvim.settings = {
          formatters = {
            pythonblack = {
              command = "${pkgs.python311Packages.black}/bin/black";
            };

          };

          formatters_by_ft = {
            python = [
              "pythonblack"
            ];
          };
        };
      };
    };

    programs.vscode.profiles.default.extensions = with pkgs.vscode-extensions; [
      ms-python.python
      ms-python.debugpy
      ms-python.vscode-pylance
    ];
  };
}

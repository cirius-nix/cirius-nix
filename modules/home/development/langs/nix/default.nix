{
  config,
  lib,
  namespace,
  pkgs,
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
    home.packages = with pkgs; [
      nixfmt-rfc-style
    ];
    programs.nixvim.plugins = {
      direnv.enable = true;
      nix.enable = true;
      nix-develop = {
        enable = true;
      };
      lsp.servers = {
        nixd.enable = true;
        nil_ls = {
          enable = true;
          settings = {
            formatting.command = [ "${lib.getExe pkgs.nixfmt-rfc-style}" ];
            nix.flake.autoArchive = true;
          };
        };
      };
      conform-nvim.settings = {
        # INFO: custom formatter to be used.
        formatters = {
          nixfmt = {
            command = lib.getExe pkgs.nixfmt-rfc-style;
          };
        };

        # INFO: use formatter(s).
        formatters_by_ft = {
          nix = [ "nixfmt" ];
        };
      };
    };

    ${namespace}.development.ide.vscode.addPlugins = with pkgs.vscode-extensions; [
      bbenoist.nix
      arrterian.nix-env-selector
      jnoortheen.nix-ide
    ];
  };
}

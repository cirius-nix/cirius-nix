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

  cfg = config.${namespace}.development.ide.nixvim.plugins.languages.shells;
in
{
  options.${namespace}.development.ide.nixvim.plugins.languages.shells = {
    enable = mkEnableOption "Enable Shells (Fish,Sh,Bash,Zsh,Dotenv) Language Server";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      shellcheck
      shellharden
      shfmt
    ];
    programs.nixvim.plugins = {
      lsp.servers = {
        fish_lsp = mkEnabled;
        bashls = mkEnabled;
      };
      conform-nvim.settings = {
        # INFO: custom formatter to be used.
        formatters = {
          shellcheck = {
            command = lib.getExe pkgs.shellcheck;
          };
          shellharden = {
            command = lib.getExe pkgs.shellharden;
          };
          shfmt = {
            command = lib.getExe pkgs.shfmt;
          };
        };

        # INFO: use formatter(s).
        formatters_by_ft = {
          bash = [
            "shellcheck"
            "shellharden"
            "shfmt"
          ];
          sh = [
            "shellcheck"
            "shellharden"
            "shfmt"
          ];
        };
      };
    };
  };
}

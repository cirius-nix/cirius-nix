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

  cfg = config.${namespace}.development.langs.shells;
in
{
  options.${namespace}.development.langs.shells = {
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
        fish_lsp.enable = true;
        bashls.enable = true;
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

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
    programs.nixvim.lsp = {
      servers = {
        bashls = {
          enable = true;
        };
        fish_lsp = {
          enable = true;
        };
      };
    };
    programs.nixvim.plugins = {
      conform-nvim.settings = {
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

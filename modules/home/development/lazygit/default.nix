{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.cirius.development.lazygit;
  deltaCfg = config.cirius.development.delta;
in
{
  options.cirius.development.lazygit = {
    enable = mkEnableOption "Lazygit";
  };

  config = mkIf cfg.enable {
    programs.lazygit = {
      inherit (cfg) enable;

      settings.git.paging = {
        pager = if deltaCfg.enable then "delta --dark --syntax-theme 'Dracula' --paging=never" else "less";
      };
    };
  };
}

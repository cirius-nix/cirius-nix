{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.cirius.packages.lazygit;
  deltaCfg = config.cirius.packages.delta;
in
{
  options.cirius.packages.lazygit = {
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

{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.cirius.clipboard;
  kdeCfg = config.cirius.kde;
in
{
  options.cirius.clipboard = {
    enable = mkEnableOption "Clipboard";
  };

  config = mkIf cfg.enable {
    environment.systemPackages =
      if kdeCfg.enable then
        [
          pkgs.wl-clipboard
          pkgs.wl-clip-persist
          pkgs.python312Packages.pyperclip
        ]
      else
        [ pkgs.xclip ];
  };
}

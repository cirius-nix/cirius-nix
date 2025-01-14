{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.${namespace}.core.clipboard;
in
{
  options.${namespace}.core.clipboard = {
    enable = mkEnableOption "Clipboard";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.wl-clipboard
      pkgs.wl-clip-persist
      pkgs.python312Packages.pyperclip
    ];
  };
}

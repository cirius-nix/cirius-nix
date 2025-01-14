{
  config,
  pkgs,
  lib,
  namespace,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.${namespace}.packages.browsers;
in
{
  options.${namespace}.packages.browsers = {
    enable = mkEnableOption "browsers";
  };

  config = mkIf (cfg.enable && !pkgs.stdenv.isDarwin) {
    home = {
      packages = with pkgs; [
        firefox
        floorp
        google-chrome
        chromium
      ];
    };
  };
}

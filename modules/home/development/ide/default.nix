{
  config,
  namespace,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.${namespace}.development.ide;
  inherit (lib) mkEnableOption;
in
{
  options.${namespace}.development.ide = {
    useJetbrainsNC = mkEnableOption "Jetbrains Noncommercial";
  };

  config = {
    home.packages =
      with pkgs;
      lib.flatten [
        (lib.optional pkgs.stdenv.isLinux [
          vscode-fhs
          filezilla
          (lib.optional cfg.useJetbrainsNC [
            jetbrains.webstorm
          ])
        ])
      ];
  };
}

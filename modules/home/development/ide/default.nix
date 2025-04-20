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
        [ pkgs.filezilla ]
        (lib.optional pkgs.stdenv.isLinux [
          vscode-fhs
          (lib.optional cfg.useJetbrainsNC [
            jetbrains.webstorm
          ])
        ])
      ];
  };
}

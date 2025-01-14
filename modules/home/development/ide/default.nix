{
  config,
  namespace,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.${namespace}.development.ide;
  nixvimCfg = config.${namespace}.development.ide.nixvim;

  inherit (lib) mkEnableOption;
in
{
  options.${namespace}.development.ide = {
    useJetbrainsNC = mkEnableOption "Jetbrains Noncommercial";
  };

  config = {
    home.packages =
      with pkgs;
      [
      ]
      ++ (
        if cfg.useJetbrainsNC then
          with pkgs;
          [
            jetbrains.webstorm
          ]
        else
          [ ]
      )
      ++ (
        if (!nixvimCfg.enable) then
          with pkgs;
          [
            vscode
          ]
        else
          [ ]
      );
  };
}

{
  config,
  namespace,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (config.${namespace}.development.ai) copilot;
  inherit (config.${namespace}.development.cli-utils) fish;
  inherit (config.${namespace}.development.ide) nixvim vscode;
in
{
  options.${namespace}.development.ai.copilot = {
    enable = mkEnableOption "Enable copilot";
    fishIntegration = {
      enable = mkEnableOption "Enable fish intergration";
    };
    vscodeIntegration = {
      enable = mkEnableOption "Enable VSCode intergration";
    };
    nixvimIntegration = {
      enable = mkEnableOption "Enable nixvim integration";
    };
  };

  config = mkIf copilot.enable {
    ${namespace}.development.cli-utils.fish = mkIf (fish.enable && copilot.fishIntegration.enable) {
      aliases = {
        "co-explain" = "${pkgs.gh}/bin/gh copilot explain";
        "co-suggest" = "${pkgs.gh}/bin/gh copilot suggest";
      };
    };
    programs.vscode.profiles.default.extensions =
      mkIf (vscode.enable && copilot.vscodeIntegration.enable)
        (
          with pkgs.vscode-extensions;
          [
            github.copilot
          ]
        );
    programs.nixvim = mkIf (nixvim.enable && copilot.nixvimIntegration.enable) {
      plugins = {
        copilot-lua.enable = true;
        copilot-cmp.enable = true;
      };
    };
  };
}

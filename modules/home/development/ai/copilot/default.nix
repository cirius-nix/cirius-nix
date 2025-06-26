{
  config,
  namespace,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (lib.${namespace}) mkStrOption;
  inherit (lib.${namespace}.nixvim) mkKeymap;
  inherit (config.${namespace}.development.ai) copilot;
  inherit (config.${namespace}.development.cli-utils) fish;
  inherit (config.${namespace}.development.ide) nixvim vscode;
in
{
  options.${namespace}.development.ai.copilot = {
    enable = mkEnableOption "Enable copilot";
    secretName = mkStrOption "copilot_auth_token" "SOPS secrets name";
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
    sops = mkIf (copilot.secretName != "") {
      secrets.${copilot.secretName} = {
        mode = "0440";
      };
    };

    ${namespace}.development = {
      cli-utils.fish = mkIf (fish.enable && copilot.fishIntegration.enable) {
        aliases = {
          "co-explain" = "${pkgs.gh}/bin/gh copilot explain";
          "co-suggest" = "${pkgs.gh}/bin/gh copilot suggest";
        };
      };
      ide.nixvim.plugins.completion.tabAutocompleteSources = mkIf (
        nixvim.enable && copilot.nixvimIntegration.enable
      ) [ "copilot" ];
    };

    programs = {
      vscode.profiles.default.extensions = mkIf (vscode.enable && copilot.vscodeIntegration.enable) (
        with pkgs.vscode-extensions; [ github.copilot ]
      );
      nixvim = mkIf (nixvim.enable && copilot.nixvimIntegration.enable) {
        keymaps = [
          (mkKeymap "<leader>las" "<cmd>Copilot status<cr>" "Check status of Copilot")
          (mkKeymap "<leader>laa" "<cmd>Copilot toggle<cr>" "Toggle Copilot")
        ];
        plugins = {
          blink-copilot = {
            enable = true;
          };
          blink-cmp = {
            settings.sources = {
              providers.copilot = {
                name = "copilot";
                module = "blink-copilot";
                score_offset = 100;
                async = true;
                opts = {
                  max_completions = 3;
                  max_attempts = 4;
                  kind_name = "Copilot";
                  kind_icon = " ";
                  kind_hl = false;
                  debounce = 200;
                  auto_refresh = {
                    backward = true;
                    forward = true;
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}

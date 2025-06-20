{
  namespace,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption mkOption;
  cfg = config.${namespace}.development.langs.typescript;
in
{
  options.${namespace}.development.langs.typescript = {
    enable = mkEnableOption "TypeScript Language Server";
    framework = {
      angular = {
        enable = mkEnableOption "Enable Angular Language Framework";
      };
    };
    enableAngularls = mkEnableOption {
      default = false;
      description = ''
        Enable Angular Language Server.
      '';
    };
    formatTimeout = mkOption {
      type = lib.types.int;
      default = 1000;
      description = ''
        Timeout in milliseconds for formatting TypeScript files.
      '';
    };
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      nodejs_22
      corepack_22
    ];
    programs.nixvim.plugins = {
      typescript-tools = {
        enable = true;
      };
      lsp.servers = {
        ts_ls = {
          enable = true;
        };
        eslint = {
          enable = true;
          filetypes = [
            "javascript"
            "javascriptreact"
            "javascript.jsx"
            "typescript"
            "typescriptreact"
            "typescript.tsx"
            "vue"
            "svelte"
            "astro"
          ];
        };
        angularls = {
          enable = cfg.enableAngularls;
          filetypes = [
            "html"
            "typescript"
          ];
          rootMarkers = [
            "angular.json"
            "project.json"
          ];
        };
      };
      conform-nvim.settings = {
        # INFO: custom formatter to be used.
        formatters = {
          prettier = {
            command = lib.getExe pkgs.nodePackages.prettier;
          };
          prettierd = {
            command = lib.getExe' pkgs.prettierd "prettier";
          };
        };

        # INFO: use formatter(s).
        formatters_by_ft = {
          javascript = {
            __unkeyed-2 = "prettierd";
            timeout_ms = cfg.formatTimeout;
            stop_after_first = true;
          };
          typescript = {
            __unkeyed-2 = "prettierd";
            stop_after_first = true;
            timeout_ms = cfg.formatTimeout;
          };
          typescriptreact = [
            "prettierd"
            "prettier"
          ];
          javascriptreact = [
            "prettierd"
            "prettier"
          ];
        };
      };
    };

    programs.vscode.profiles.default.extensions =
      with pkgs.vscode-extensions;
      [
        esbenp.prettier-vscode
        dbaeumer.vscode-eslint
      ]
      # TODO: include plugins for angular, react, etc.
      ++ (lib.optionals cfg.framework.angular.enable [
        # "nrwl.angular-console",
        # "ms-playwright.playwright"
      ]);
  };
}

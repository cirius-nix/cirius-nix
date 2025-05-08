{
  namespace,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    ;

  cfg = config.${namespace}.development.langs.markup;
in
{
  options.${namespace}.development.langs.markup = {
    enable = mkEnableOption "Enable Markup Language Server";
  };

  config = mkIf cfg.enable {
    ${namespace}.development.ide.vscode.addPlugins = with pkgs.vscode-extensions; [
      bradlc.vscode-tailwindcss
      redhat.vscode-yaml
    ];
    home.packages = with pkgs; [
      stylelint
      deno
      prettierd
      nodePackages.prettier
    ];
    programs.nixvim.plugins = {
      lsp.servers = {
        cssls.enable = true;
        html.enable = true;
        markdown_oxide.enable = true;
        tailwindcss.enable = true;
        eslint = {
          enable = true;
          filetypes = [
            "html"
          ];
        };
      };
      conform-nvim.settings = {
        # INFO: custom formatter to be used.
        formatters = {
          stylelint = {
            command = lib.getExe pkgs.stylelint;
          };
          deno_fmt = {
            # Fantatic tool supports: JavaScript, TypeScript, Markdown, JSON(C) and Jupyter Notebooks
            command = lib.getExe pkgs.deno;
          };
          css = [ "stylelint" ];
          html = {
            __unkeyed-2 = "prettier";
            timeout_ms = 5000; # set longer timeout because of poor performance of prettier.
            stop_after_first = true;
          };
          prettier = {
            command = lib.getExe pkgs.nodePackages.prettier;
          };
        };

        # INFO: use formatter(s).
        formatters_by_ft = {
          markdown = [ "deno_fmt" ];
        };
      };
    };
  };
}

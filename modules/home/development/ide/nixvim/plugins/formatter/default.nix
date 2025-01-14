{
  lib,
  namespace,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.${namespace}.development.ide.nixvim.plugins.formatter;
  langCfg = config.${namespace}.development.ide.nixvim.plugins.languages;
in
{
  options.${namespace}.development.ide.nixvim.plugins.formatter = {
    enable = mkEnableOption "Formatter support";
  };

  config = mkIf cfg.enable {
    programs.nixvim = {
      plugins = {
        conform-nvim = {
          enable = true;
          settings = {
            format_on_save = # Lua
              ''
                function(bufnr)
                  if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
                    return
                  end

                  if slow_format_filetypes[vim.bo[bufnr].filetype] then
                    return
                  end

                  local function on_format(err)
                    if err and err:match("timeout$") then
                      slow_format_filetypes[vim.bo[bufnr].filetype] = true
                    end
                  end

                  return { timeout_ms = 2000, lsp_fallback = true }, on_format
                 end
              '';

            format_after_save = # Lua
              ''
                function(bufnr)
                  if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
                    return
                  end

                  if not slow_format_filetypes[vim.bo[bufnr].filetype] then
                    return
                  end

                  return { lsp_fallback = true }
                end
              '';
            formatters_by_ft = {
              go = [
                "goimports"
                "goimports-reviser"
              ];
              bash = [
                "shellcheck"
                "shellharden"
                "shfmt"
              ];
              bicep = [ "bicep" ];
              c = [ "clang_format" ];
              cmake = [ "cmake-format" ];
              css = [ "stylelint" ];
              fish = [ "fish_indent" ];
              html = {
                __unkeyed-2 = "prettier";
                timeout_ms = 5000;
                stop_after_first = true;
              };
              javascript = {
                __unkeyed-2 = "prettier";
                timeout_ms = 2000;
                stop_after_first = true;
              };
              json = [ "jq" ];
              lua = [ "stylua" ];
              markdown = [ "deno_fmt" ];
              nix = [ "nixfmt" ];
              python = [
                "isort"
                "ruff"
              ];
              rust = [ "rustfmt" ];
              sh = [
                "shellcheck"
                "shellharden"
                "shfmt"
              ];
              sql = [
                "sql_formatter"
              ];
              terraform = [ "terraform_fmt" ];
              toml = [ "taplo" ];
              typescript = mkIf langCfg.typescript.enable {
                __unkeyed-2 = "prettier";
                stop_after_first = true;
                timeout_ms = langCfg.typescript.formatTimeout;
              };
              xml = [
                "xmlformat"
                "xmllint"
              ];
              yaml = [ "yamlfmt" ];
            };

            formatters = {
              sql_formatter = {
                prepend_args = {
                  __raw = ''
                    { "-c", vim.fn.expand("~/.config/sql_formatter.json") },
                  '';
                };
              };
              taplo = {
                command = lib.getExe pkgs.taplo;
              };
              black = {
                command = lib.getExe pkgs.black;
              };
              prettier = mkIf langCfg.typescript.enable {
                command = lib.getExe pkgs.nodePackages.prettier;
              };
              bicep = {
                command = lib.getExe pkgs.bicep;
              };
              cmake-format = {
                command = lib.getExe pkgs.cmake-format;
              };
              deno_fmt = {
                command = lib.getExe pkgs.deno;
              };
              google-java-format = {
                command = lib.getExe pkgs.google-java-format;
              };
              jq = {
                command = lib.getExe pkgs.jq;
              };
              nixfmt = {
                command = lib.getExe pkgs.nixfmt-rfc-style;
              };
              ruff = {
                command = lib.getExe pkgs.ruff;
              };
              rustfmt = {
                command = lib.getExe pkgs.rustfmt;
              };
              shellcheck = {
                command = lib.getExe pkgs.shellcheck;
              };
              shfmt = {
                command = lib.getExe pkgs.shfmt;
              };
              shellharden = {
                command = lib.getExe pkgs.shellharden;
              };
              sqlfluff = {
                command = lib.getExe pkgs.sqlfluff;
              };
              stylelint = {
                command = lib.getExe pkgs.stylelint;
              };
              stylua = {
                command = lib.getExe pkgs.stylua;
              };
              terraform_fmt = {
                command = lib.getExe pkgs.terraform;
              };
              yamlfmt = {
                command = lib.getExe pkgs.yamlfmt;
              };
            };
          };
        };
      };
    };
  };
}

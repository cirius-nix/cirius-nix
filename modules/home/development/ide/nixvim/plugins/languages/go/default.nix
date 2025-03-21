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
  inherit (lib.${namespace}.nixvim) mkEnabled;

  cfg = config.${namespace}.development.ide.nixvim.plugins.languages.go;

in
{
  options.${namespace}.development.ide.nixvim.plugins.languages.go = {
    enable = mkEnableOption "Enable Go Language Server";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      # authtest benchcmp bisect bundle callgraph compilebench cookieauth
      # deadcode defers digraph eg fieldalignment file2fuzz findcall fiximports
      # fuzz-driver fuzz-runner gitauth go-contrib-init godex godoc goimports
      # gomvpkg gonew gopackages gorename gostacks gotype goyacc html2article
      # httpmux ifaceassert lostcancel netrcauth nilness nodecount play present
      # present2md shadow splitdwarf ssadump stress stringer stringintconv
      # toolstash unmarshal unusedresult
      gotools
      goimports-reviser
    ];
    programs.nixvim.extraConfigLuaPost = ''
      vim.filetype.add({
        extension = {
          gotmpl = 'gotmpl',
        },
        pattern = {
          [".*/templates/.*%.tpl"] = "helm",
          [".*/templates/.*%.ya?ml"] = "helm",
          ["helmfile.*%.ya?ml"] = "helm",
        },
      })
    '';
    programs.nixvim.plugins = {
      lsp.servers = {
        gopls = mkEnabled;
      };
      conform-nvim.settings = {
        # INFO: custom formatter to be used.
        formatters = {
          goimports = {
            command = "${pkgs.gotools}/bin/goimports";
          };
          goimports-reviser = {
            command = lib.getExe pkgs.goimports-reviser;
          };
        };

        # INFO: use formatter(s).
        formatters_by_ft = {
          go = [
            "goimports"
            "goimports-reviser"
          ];
        };
      };
    };
  };
}

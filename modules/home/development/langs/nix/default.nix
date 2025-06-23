{
  config,
  lib,
  namespace,
  pkgs,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.${namespace}.development.langs.nix;
in
{
  options.${namespace}.development.langs.nix = {
    enable = mkEnableOption "Nix Language";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      nixfmt-rfc-style
    ];
    services.lorri = mkIf pkgs.stdenv.isLinux {
      enable = true;
    };
    programs.nixvim = {
      lsp.servers = {
        nixd.enable = true;
        nixd.settings =
          let
            flake = ''(builtins.getFlake (builtins.toString ./.))'';
          in
          {
            nixpkgs = {
              expr = "import ${flake}.inputs.nixpkgs { }";
            };
            formatting = {
              command = [ "${lib.getExe pkgs.nixfmt-rfc-style}" ];
            };
            options = {
              nix-darwin.expr = ''${flake}.darwinConfigurations.cirius-darwin.options'';
              nixos.expr = ''${flake}.nixosConfigurations.cirius.options'';
              nixvim.expr = ''${flake}.packages.${pkgs.system}.nvim.options'';
              home-manager.expr = ''${flake}.homeConfigurations."cirius@cirius".options'';
            };
          };
        nil_ls = {
          enable = true;
          settings = {
            formatting.command = [ "${lib.getExe pkgs.nixfmt-rfc-style}" ];
            nix.flake.autoArchive = true;
          };
        };
      };

      plugins = {
        direnv.enable = true;
        nix.enable = true;
        nix-develop = {
          enable = true;
        };
        none-ls = {
          sources.code_actions = {
            statix.enable = true;
          };
        };
        conform-nvim.settings = {
          # INFO: custom formatter to be used.
          formatters = {
            nixfmt = {
              command = lib.getExe pkgs.nixfmt-rfc-style;
            };
          };

          # INFO: use formatter(s).
          formatters_by_ft = {
            nix = [ "nixfmt" ];
          };
        };
      };
    };

    programs.vscode = {
      profiles.default = {
        extensions = with pkgs.vscode-extensions; [
          bbenoist.nix
          arrterian.nix-env-selector
          jnoortheen.nix-ide
        ];
        userSettings = {
          "nix.enableLanguageServer" = true;
          "nix.serverPath" = "nixd";
          "nix.formatterPath" = "nixpkgs-fmt";
          "nix.serverSettings" = {
            "nixd" = {
              "formatting" = {
                "command" = [ "nixpkgs-fmt" ];
              };
            };
          };
        };
      };
    };
  };
}

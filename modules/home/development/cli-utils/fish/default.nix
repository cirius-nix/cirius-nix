{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:

let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    concatMapStringsSep
    optional
    ;
  devCfg = config.${namespace}.development;
  cfg = devCfg.cli-utils.fish;
  goCfg = devCfg.langs.go;
  fastFetchCfg = devCfg.cli-utils.fastfetch;

  initialPaths = [ "~/.local/bin" ] ++ optional goCfg.enable "~/go/bin";
  aliases = {
    "ns" = "nix-shell";
  };
in
{
  options.${namespace}.development.cli-utils.fish = {
    enable = mkEnableOption "Shell configuration";
    customPaths = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "List of custom paths to add to the PATH";
    };
    aliases = mkOption {
      type = types.attrsOf types.str;
      default = { };
      description = "List of aliases to add";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      nix-your-shell
    ];
    programs.fish = {
      enable = true;
      shellAliases = aliases // cfg.aliases;
      interactiveShellInit =
        ''
          # disable greeting
          set fish_greeting # Disable greeting

          ${pkgs.thefuck}/bin/thefuck --alias | source

          # Editor
          set -g EDITOR nvim
          set -g PSQL_EDITOR nvim

          # PAGER tool
          set -g PAGER ${pkgs.less}/bin/less -S

          # Set golang binary directory
          set -g GOBIN $HOME/go/bin

          function aws_profile
            set profile $argv[1]
            set -e argv[1]

            ${pkgs.aws-vault}/bin/aws-vault exec $profile fish -d 12h $argv
          end

          ${concatMapStringsSep "\n" (path: ''
            if test -d ${path}
              if not contains ${path} $PATH
                set -p PATH ${path}
              end
            end
          '') (initialPaths ++ cfg.customPaths)}

          ${pkgs.nix-your-shell}/bin/nix-your-shell fish | source
        ''
        + (lib.optionalString (fastFetchCfg.enable) ''
          ${pkgs.fastfetch}/bin/fastfetch
        '');
      plugins = [
        {
          name = "z";
          src = pkgs.fetchFromGitHub {
            owner = "jethrokuan";
            repo = "z";
            rev = "e0e1b9dfdba362f8ab1ae8c1afc7ccf62b89f7eb";
            sha256 = "0dbnir6jbwjpjalz14snzd3cgdysgcs3raznsijd6savad3qhijc";
          };
        }
        {
          name = "autopair";
          inherit (pkgs.fishPlugins.autopair) src;
        }
        {
          name = "forgit";
          inherit (pkgs.fishPlugins.forgit) src;
        }
        {
          name = "fzf-fish";
          inherit (pkgs.fishPlugins.fzf-fish) src;
        }
      ];
    };
  };
}

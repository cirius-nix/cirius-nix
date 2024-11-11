{ config
, lib
, pkgs
, ...
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

  devCfg = config.cirius.development;

  cfg = devCfg.fish;
  goCfg = devCfg.go;
  initialPaths = [ "~/.local/bin" ] ++ optional goCfg.enable "~/go/bin";
  aliases = {
    "ns" = "nix-shell";
  };
in
{
  options.cirius.development.fish = {
    enable = mkEnableOption "Shell configuration";
    customPaths = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "List of custom paths to add to the PATH";
    };
    aliases = mkOption {
      type = types.attrs;
      default = { };
      description = "List of aliases to add";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs;[ any-nix-shell ];

    programs.fish = {
      inherit (cfg) enable;
      shellAliases = aliases // cfg.aliases;
      interactiveShellInit = ''
        ${pkgs.any-nix-shell}/bin/any-nix-shell fish --info-right | source

        set fish_greeting # Disable greeting
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
      '';

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

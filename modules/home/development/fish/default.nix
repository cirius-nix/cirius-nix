{
  config,
  lib,
  pkgs,
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

  devCfg = config.cirius.development;

  cfg = devCfg.fish;
  goCfg = devCfg.go;
  initialPaths = [ "~/.local/bin" ] ++ optional goCfg.enable "~/go/bin";
in
{
  options.cirius.development.fish = {
    enable = mkEnableOption "Shell configuration";
    customPaths = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "List of custom paths to add to the PATH";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ ];

    programs.fish = {
      inherit (cfg) enable;

      interactiveShellInit = ''
        set fish_greeting # Disable greeting

        function aws_profile
          set profile $argv[1]
          set -e argv[1]

          aws-vault exec $profile fish -d 12h $argv
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

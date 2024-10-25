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
    ;
  cfg = config.cirius.development.fish;
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

        # Process custom paths
        ${concatMapStringsSep "\n" (path: ''
          if test -d ${path}
            if not contains ${path} $PATH
              set -p PATH ${path}
            end
          end
        '') cfg.customPaths}
      '';
    };
  };
}

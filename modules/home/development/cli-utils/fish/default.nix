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
    ;
  devCfg = config.${namespace}.development;
  cfg = devCfg.cli-utils.fish;

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
    interactiveEnvs = mkOption {
      type = types.attrsOf types.str;
      default = { };
      description = "List of interactive envs to add";
    };
    interactiveCommands = mkOption {
      type = types.listOf types.str;
      default = [
        "${pkgs.nix-your-shell}/bin/nix-your-shell fish | source"
      ];
      description = "List of commands to run in interactive shell";
    };
    interactiveFuncs = mkOption {
      type = types.attrsOf types.str;
      default = { };
      description = "List of interactive functions to add";
    };
  };

  config = mkIf cfg.enable {
    # TODO: move this to nix configuration.
    programs.nix-your-shell = {
      enable = true;
      enableFishIntegration = true;
    };

    programs.fish = {
      enable = true;
      shellAliases = lib.mkMerge [
        {
          "ns" = "nix-shell";
        }
        cfg.aliases
      ];
      interactiveShellInit =
        let
          mergedEnvs = lib.foldl' lib.attrsets.recursiveUpdate { } [ cfg.interactiveEnvs ];
          envsStr = lib.concatStringsSep "\n" (
            lib.mapAttrsToList (name: value: "set -gx ${name} ${value}") mergedEnvs
          );

          mergedFuncs = lib.foldl' lib.attrsets.recursiveUpdate { } [ cfg.interactiveFuncs ];
          funcsStr = lib.concatStringsSep "\n" (
            lib.mapAttrsToList (name: value: ''
              function ${name}
                ${value}
              end
            '') mergedFuncs
          );

          listPaths = lib.unique (
            lib.concatLists [
              [ "$HOME/.local/bin" ]
              cfg.customPaths
            ]
          );

          pathsStrs = lib.concatMapStringsSep "\n" (path: ''
            if test -d ${path}
              if not contains ${path} $PATH
                set -p PATH ${path}
              end
            end
          '') listPaths;

          mergedCommands = lib.unique (lib.concatLists [ cfg.interactiveCommands ]);
          listCommandsStr = lib.concatStringsSep "\n" mergedCommands;
        in
        lib.concatStringsSep "\n" [
          "set fish_greeting # disable default greeting"
          "# Interactive environments"
          envsStr
          "# Interactive functions"
          funcsStr
          "# Interactive paths"
          pathsStrs
          "# Interactive commands"
          listCommandsStr
        ];

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
          name = "fzf-fish";
          inherit (pkgs.fishPlugins.fzf-fish) src;
        }
      ];
    };
  };
}

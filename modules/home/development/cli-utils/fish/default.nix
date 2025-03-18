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
    home.packages = with pkgs; [
      nix-your-shell
    ];

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
          # Use Case                                  | mkMerge    | Use foldl' lib.attrsets.recursiveUpdate
          # ------------------------------------------|------------|--------------------------------------
          # Inside `options` or `config`              | ✅ Yes     | ❌ No
          # Dynamic merging in `let` bindings         | ❌ No      | ✅ Yes
          # Works with multiple option sets           | ✅ Yes     | ❌ No
          # Merging attribute sets dynamically        | ❌ No      | ✅ Yes
          #  Understanding foldl' lib.attrsets.recursiveUpdate in Nix
          # 1️⃣ What is foldl'?
          #
          # foldl' (left fold) reduces a list to a single value by applying a function repeatedly.
          #
          #     It takes an initial value and a list, then applies the function from left to right.
          #
          # 2️⃣ What is lib.attrsets.recursiveUpdate?
          #
          # lib.attrsets.recursiveUpdate merges two attribute sets.
          #
          #     If an attribute exists in both sets, the second one overrides the first.
          #     If attributes are nested, it merges them recursively.

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

{ config
, pkgs
, lib
, ...
}:

let
  inherit (builtins) any listToAttrs;
  inherit (lib) mkEnableOption mkIf mkOption;
  inherit (lib.cirius) mkEnumOption mkStrOption;
  inherit (lib.types) listOf submodule;

  cfg = config.cirius.users;

  user = {
    options = {
      username = mkStrOption null "The name of the user account.";
      name = mkStrOption null "The full name of the user.";
      email = mkStrOption null "The e-mail address of the user.";
      shell = mkEnumOption [
        "bash"
        "fish"
      ] "fish" "User shell.";
    };
  };
  enabledFish = any (user: user.shell == "fish") cfg.users;
in

{
  options = {
    cirius.users = {
      enable = mkEnableOption "Users";
      users = mkOption {
        type = listOf (submodule user);
        default = [ ];
      };
    };
  };

  config = mkIf cfg.enable {
    programs = {
      fish.enable = enabledFish;
      bash = mkIf enabledFish {
        interactiveShellInit = '''';
      };
    };

    users.users = listToAttrs (
      map
        (user: {
          name = user.username;
          value = {
            description = user.name;
            shell = pkgs.${user.shell};
          };
        })
        cfg.users
    );
  };
}

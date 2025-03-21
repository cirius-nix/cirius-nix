{
  config,
  namespace,
  lib,
  ...
}:
let
  inherit (lib.${namespace}) mkStrOption;
in
{
  options = {
    ${namespace}.user = {
      # config.snowfallorg.user.name
      # The name of the user. This value is provided to home-manager’s home.username
      # option during automatic configuration. This option does not have a
      # default value, but one is set automatically by Snowfall Lib for each
      # user. Most commonly this value can be accessed by other modules with
      # config.snowfallorg.user.name to get the current user’s name;
      username = mkStrOption config.snowfallorg.user.name "Username";
      # config.snowfallorg.user.home;
      # By default, the user’s home directory will be calculated based on the
      # platform and provided username. However, this can still be customized
      # if your user’s home directory is in a non-standard location.
      homeDir = mkStrOption config.snowfallorg.user.home.directory "Home directory";
      # email address of user.
      email = mkStrOption "" "Email address";
      # name of the user.
      name = mkStrOption "" "Pretty name of the user";
    };
  };
}

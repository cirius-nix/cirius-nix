{
  namespace,
  lib,
  pkgs,
  ...
}:
{
  options.${namespace}.development.ide = {
  };

  config = {
    home.packages =
      with pkgs;

      lib.flatten [
        (lib.optional pkgs.stdenv.isLinux [
          filezilla
        ])
      ];
  };
}

{
  config,
  lib,
  namespace,
  ...
}:
let

  inherit (lib)
    mkIf
    ;

  inherit (config.${namespace}.development.ide) nixvim;
in
{
  config = mkIf nixvim.enable {
    programs.nixvim.extraConfigLuaPre = '''';
  };
}

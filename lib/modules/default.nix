{ lib, ... }:
let
  inherit (lib) mkOption;
  inherit (lib.lists) findFirst;
  inherit (lib.types)
    enum
    int
    nullOr
    package
    str
    ;
in
{
  findOrNull =
    list: attribute: value:
    findFirst (x: x.${attribute} == value) null list;

  mkEnumOption =
    values: default: description:
    mkOption {
      inherit default description;
      type = nullOr (enum values);
    };

  mkStrOption =
    default: description:
    mkOption {
      inherit default description;
      type = nullOr str;
    };

  mkIntOption =
    default: description:
    mkOption {
      inherit default description;
      type = nullOr int;
    };

  mkPackageOption =
    default: description:
    mkOption {
      inherit default description;
      type = package;
    };
}

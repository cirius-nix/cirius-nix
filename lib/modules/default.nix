{
  lib,
  ...
}:
let
  inherit (lib) mapAttrs mkOption types;
  inherit (lib.lists) findFirst;
  inherit (lib.types)
    enum
    int
    nullOr
    package
    str
    listOf
    attrsOf
    ;
in
rec {
  findOrNull =
    list: attribute: value:
    findFirst (x: x.${attribute} == value) null list;
  mkEnumOption =
    values: default: description:
    mkOption {
      inherit default description;
      type = nullOr (enum values);
    };
  mkListOption =
    type: default: description:
    mkOption {
      inherit default description;
      type = nullOr (listOf type);
    };
  mkAttrsOption =
    type: default: description:
    mkOption {
      inherit default description;
      type = nullOr (attrsOf type);
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
  mkOpt =
    type: default: description:
    mkOption { inherit type default description; };
  mkOpt' = type: default: mkOpt type default null;
  mkBoolOpt = mkOpt types.bool;
  mkBoolOpt' = mkOpt' types.bool;
  enabled = {
    enable = true;
  };
  disabled = {
    enable = false;
  };
  capitalize =
    s:
    let
      len = lib.stringLength s;
    in
    if len == 0 then "" else (lib.toUpper (lib.substring 0 1 s)) + (lib.substring 1 len s);
  boolToNum = bool: if bool then 1 else 0;
  default-attrs = mapAttrs (_key: lib.mkDefault);
  force-attrs = mapAttrs (_key: lib.mkForce);
  nested-default-attrs = mapAttrs (_key: default-attrs);
  nested-force-attrs = mapAttrs (_key: force-attrs);
}

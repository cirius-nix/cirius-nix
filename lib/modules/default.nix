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
  mkEnabled = {
    enable = true;
  };
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
  subModuleType =
    opts:
    types.submodule {
      options = opts;
    };
  mkAttrsOption =
    type: default: description:
    mkOption {
      inherit default description;
      type = nullOr (attrsOf type);
    };
  mkPathOption =
    default: description:
    mkOption {
      inherit default description;
      type = nullOr types.path;
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
  # example: mergeL' { a = 1; b = 2; } [{ a = 2; b = 3; c = 4; }] => { a = 2; b = 3; c = 4; }
  mergeL' = default: attrSets: lib.foldl' lib.recursiveUpdate default attrSets;
  optionalGet =
    path: set:
    let
      step = acc: key: if acc == null then null else acc.${key} or null;
    in
    builtins.foldl' step set path;
  ifNullThen = set: def: if set == null then def else set;
}

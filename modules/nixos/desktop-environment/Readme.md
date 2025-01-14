# Desktop Environment

This folder contains the configuration for the desktop environment.

## List

- [x] Hyprland

### Template

```nix
{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkIf types;
  inherit (lib.${namespace}) mkBoolOpt mkOpt enabled;
  cfg = config.${namespace}.desktop-environment.desktop_environment;
in
{
  options.${namespace}.desktop-environment.desktop_environment = with types; {
    enable = mkBoolOpt false "Enable desktop_environment";
    customConfigFiles =
      mkOpt attrs { }
        "Custom configuration files that can be used to override the default files.";
    customFiles = mkOpt attrs { } "Custom files that can be used to override the default files.";
    wallpaper = mkOpt (nullOr package) null "The wallpaper to display.";
  };

  config = mkIf cfg.enable {
    programs.desktop_environment.enable = true;
    environment = {
      etc."greetd/environments".text = ''"desktop_environment"'';
      sessionVariables = {
      };
    };

    cirius = {
      # enable if needed.
      keyring = enabled;
      polkit = enabled;
      wlroots = enabled;
    };
  };
}
```

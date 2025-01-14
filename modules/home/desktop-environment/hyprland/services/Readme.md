# Services

Setting up required services for hyprland desktop environment.

Service defined here must be under `services` options or provide new
`systemd.user.services` options.

## Modules

- [x] Swaync: Notification center for listing notifications purpose.
- [x] Mako: Notification daemon for displaying new notifications.
- [x] Hyprpaper: Desktop background manager.

### Usage

Contains required services for hyprland.

### Template

NOTE: Remember to replace `service_name` with your own service name.

```nix
{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    ;
  cfg = config.${namespace}.desktop-environment.hyprland.services.service_name;
in
{
  options.${namespace}.desktop-environment.hyprland.services.service_name = {
    enable = mkEnableOption "service_name";
  };

  config = mkIf cfg.enable {
    systemd.user.services.service_name = {
      # systemd configuration. See example in .../mako/default.nix
    };

    services = {
      service_name = {
        enable = true;
        settings = {
        };
      };
    };
  };
}
```

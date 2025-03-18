# this package contains system configuration for hyprland.
# for the user configuration, go to home manager config for that.
{
  config,
  lib,
  namespace,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkIf
    types
    concatStringsSep
    makeBinPath
    ;
  inherit (lib.${namespace}) mkOpt enabled;
  deCfg = config.${namespace}.desktop-environment;

  pp-programs = makeBinPath (
    with pkgs;
    [
      hyprland
      coreutils
      config.services.power-profiles-daemon.package
      systemd
      libnotify
    ]
  );
in
{
  options.${namespace}.desktop-environment.hyprland = with types; {
    customConfigFiles =
      mkOpt attrs { }
        "Custom configuration files that can be used to override the default files.";
    customFiles = mkOpt attrs { } "Custom files that can be used to override the default files.";
  };

  config = mkIf (deCfg.kind == "hyprland") {
    programs.hyprland = {
      enable = true;
      withUWSM = true;
    };
    environment = {
      etc."greetd/environments".text = ''"Hyprland"'';
      sessionVariables = {
      };
      systemPackages = with pkgs; [
        wayland-utils
        egl-wayland
      ];
    };
    services = {
      displayManager.sddm.enable = true;
      desktopManager.plasma6.enable = true;
      xserver = {
        enable = true;
        xkb = {
          layout = "us";
          variant = "";
        };
      };
      printing.enable = false;
      power-profiles-daemon.enable = true;
    };
    ${namespace} = {
      core = {
        keyring = enabled;
        polkit = enabled;
        wlroots = enabled;
        power-profile = {
          enable = true;
          startscript = # bash
            ''
              export PATH=$PATH:${pp-programs}
              export HYPRLAND_INSTANCE_SIGNATURE=$(command ls -t $XDG_RUNTIME_DIR/hypr | head -n 1)
              hyprctl --batch '${
                concatStringsSep " " [
                  "keyword animations:enabled 0;"
                  "keyword decoration:drop_shadow 0;"
                  "keyword decoration:blur:enabled 0;"
                  "keyword misc:vfr 0"
                ]
              }'
              powerprofilesctl set performance
              notify-send -a 'Gamemode' 'Optimizations activated' -u 'low'
            '';

          endscript = # bash
            ''
              export PATH=$PATH:${pp-programs}
              export HYPRLAND_INSTANCE_SIGNATURE=$(command ls -t $XDG_RUNTIME_DIR/hypr | head -n 1)
              hyprctl --batch '${
                concatStringsSep " " [
                  "keyword animations:enabled 1;"
                  "keyword decoration:drop_shadow 1;"
                  "keyword decoration:blur:enabled 1;"
                  "keyword misc:vfr 1"
                ]
              }'
              powerprofilesctl set balanced
              notify-send -a 'Gamemode' 'Optimizations deactivated' -u 'low'
            '';
        };
      };

    };
  };
}

{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
if pkgs.stdenv.isDarwin then
  { }
else
  let
    inherit (lib)
      mkIf
      getExe
      types
      mkOption
      mkMerge
      ;

    inherit (lib.${namespace}) mkOpt mkAttrsOption;
    deCfg = config.${namespace}.desktop-environment;
    cfg = deCfg.hyprland;

    rulesWinv2Enum = [
      "center"
      "opacity"
      "size"
      "move"
      "pin"
      "float"
      "tile"
      "workspace"
      "idleinhibit"
    ];
  in
  {
    imports = lib.snowfall.fs.get-non-default-nix-files ./.;
    options.${namespace}.desktop-environment.hyprland = {
      coreVariables = mkOption {
        type = types.submodule {
          options = {
            # modifiers
            mainMod = mkOpt types.str "SUPER" "The main mod key";
            hyper = mkOpt types.str "SUPER_SHIFT_CTRL" "The hyper key";
            rHyper = mkOpt types.str "SUPER_ALT_R_CTRL_R" "The right hyper key";
            lHyper = mkOpt types.str "SUPER_ALT_L_CTRL_L" "The left hyper key";
            aHyper = mkOpt types.str "SUPER_ALT_CTRL" "The alt hyper key";

            # application variables.
            editor = mkOpt types.str (getExe pkgs.neovim) "The editor - Neovim";
          };
        };
      };
      variables = mkOption {
        type = types.attrsOf types.str;
        default = {
          browser = mkOpt types.str (getExe pkgs.firefox) "The browser - Firefox";
        };
        description = "Custom variables for hyprland.";
      };
      shortcuts = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = "Custom shortcuts for hyprland";
      };
      enableGreeting = mkOpt types.bool false "Enable the greeting";
      theme = mkOpt types.str "gruvbox" "The theme to use";
      appendConfig = lib.mkOption {
        type = lib.types.lines;
        default = "";
      };
      prependConfig = lib.mkOption {
        type = lib.types.lines;
        default = "";
      };
      events = {
        onEmptyWorkspaces = mkAttrsOption (with lib.types; listOf str) { } "Set event on empty workspaces";
      };
      rules = {
        winv2 = lib.genAttrs rulesWinv2Enum (
          rule: mkAttrsOption (with lib.types; listOf str) { } "Set ${rule} rules"
        );
      };
    };
    config = mkIf (deCfg.kind == "hyprland") {
      wayland.windowManager.hyprland =
        let
          systemctl = lib.getExe' pkgs.systemd "systemctl";
        in
        {
          enable = true;
          extraConfig = ''
            ### EXTRA CONFIG ###
            monitor = , preferred, auto, 1.5
            ${cfg.prependConfig}
            ${cfg.appendConfig}
          '';
          systemd = {
            enable = true;
            enableXdgAutostart = true;
            extraCommands = [
              "${systemctl} --user stop hyprland-session.target"
              "${systemctl} --user reset-failed"
              "${systemctl} --user start hyprland-session.target"
            ];
            variables = [
              "--all"
            ];
          };
          xwayland.enable = true;
          settings =
            let
              # - Make default greeting options.
              # - Executes "Hello $(whoami)" in libnotify.
              greetingOpts = (
                lib.optionalAttrs cfg.enableGreeting {
                  exec = [ "${getExe pkgs.libnotify} --icon ~/.face -u normal \"Hello $(whoami)\"" ];
                  monitor = ",preferred,auto,1.5";
                }
              );

              # - Loops over all attributes in vals.
              # - Checks if the key starts with $ using lib.hasPrefix "$" name.
              # - If not, it adds $ to the beginning.
              # - Returns the modified key-value pairs.
              mapVals =
                vals:
                lib.mapAttrs' (
                  name: val: lib.nameValuePair (if lib.hasPrefix "$" name then name else "$" + name) val
                ) vals;

              # mergedVals will be used for coreVariables and variables
              # coreVariables has types of submodule, variables has attrsOf str. So
              # we cannot use mkMerge directly.
              # Solution:
              # ✔ Uses `recursiveUpdate` instead of mkMerge to properly combine
              # coreVariables and variables.
              # ✔ Ensures keys in coreVariables can be overridden in variables.
              # ✔ Prefixes $ only if missing using mapAttrs'.
              # ✔ More readable and structured Nix code.
              mergedVals = lib.recursiveUpdate cfg.variables cfg.coreVariables;

              # Example config:
              # cfg.enableGreeting = true;
              # cfg.coreVariables = { hyper = "SUPER_SHIFT_CTRL"; };
              # cfg.variables = { mainMod = "SUPER"; };
              # cfg.shortcuts = [
              #   "$mainMod, B, exec, $browser"
              # ];

              onEmptyWorkspaceHandlers = lib.mapAttrsToList (
                name: values: map (value: "${name}, on-created-empty:${value}") values
              ) cfg.events.onEmptyWorkspaces;

            in
            mkMerge [
              {
                workspace =
                  let
                    mapEvent =
                      eventName: events:
                      (lib.mapAttrsToList (name: values: map (value: "${name}, ${eventName}:${value}") values) events);
                  in
                  lib.unique (
                    lib.flatten [
                      (mapEvent "on-created-empty" cfg.events.onEmptyWorkspaces)
                    ]
                  );
              }
              # Greeting
              greetingOpts
              # Mappings
              (mapVals mergedVals)
              # Shortcuts
              {
                bind = lib.unique (lib.concatLists [ cfg.shortcuts ]);
              }
              {
                windowrulev2 =
                  let
                    mapRules =
                      rule: defs:
                      (lib.mapAttrsToList (name: values: (map (value: "${rule} ${name}, ${value}") values)) defs);
                  in
                  lib.unique (lib.flatten (map (rule: mapRules rule cfg.rules.winv2.${rule}) rulesWinv2Enum));
              }
            ];
        };
      home =
        let
          inherit (cfg.themes) activatedTheme;
        in
        {
          packages = with pkgs; [
            grim
            slurp
            libgcc
          ];
          pointerCursor =
            {
              x11.enable = true;
            }
            // mkIf (activatedTheme != null) {
              inherit (activatedTheme.cursor) name package size;
            };
          sessionVariables =
            {
              CLUTTER_BACKEND = "wayland";
              GDK_BACKEND = "wayland,x11";
              MOZ_ENABLE_WAYLAND = "1";
              MOZ_USE_XINPUT2 = "1";
              WLR_DRM_NO_ATOMIC = "1";
              XDG_SESSION_TYPE = "wayland";
              _JAVA_AWT_WM_NONREPARENTING = "1";
              __GL_GSYNC_ALLOWED = "0";
              __GL_VRR_ALLOWED = "0";
            }
            ### Use xcursor for qt5,6ct and gtk3,4
            // mkIf (activatedTheme != null) {
              CURSOR_THEME = activatedTheme.cursor.name;
              XCURSOR_SIZE = activatedTheme.cursor.size;
              XCURSOR_THEME = activatedTheme.cursor.name;
            };
        };
    };
  }

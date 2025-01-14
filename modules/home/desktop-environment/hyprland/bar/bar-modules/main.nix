{ lib, pkgs, ... }:
let
  inherit (lib) getExe getExe';
in
{
  backlight =
    let
      brightnessctl = lib.getExe pkgs.brightnessctl;
    in
    {
      format = "{icon}";
      format-icons = [
        "󰋙"
        "󰫃"
        "󰫄"
        "󰫅"
        "󰫆"
        "󰫇"
        "󰫈"
      ];
      on-scroll-up = "${brightnessctl} s 1%-";
      on-scroll-down = "${brightnessctl} s +1%";
    };

  battery = {
    states = {
      warning = 30;
      critical = 15;
    };
    format = "{icon}";
    format-charging = "󰂄";
    format-plugged = "󰂄";
    format-alt = "{icon}";
    format-icons = [
      "󰂃"
      "󰁺"
      "󰁻"
      "󰁼"
      "󰁽"
      "󰁾"
      "󰁾"
      "󰁿"
      "󰂀"
      "󰂁"
      "󰂂"
      "󰁹"
    ];
  };

  bluetooth = {
    format = "";
    format-disabled = "󰂲";
    format-connected = "󰂱";
    tooltip-format = "{controller_alias}\t{controller_address}";
    tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{device_enumerate}";
    tooltip-format-disabled = "";
    tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
    on-click = "blueman-manager";
  };

  cava = {
    framerate = 120;
    autosens = 1;
    bars = 12;
    method = "pipewire";
    source = "auto";
    bar_delimiter = 0;
    input_delay = 2;
    sleep_timer = 2;
    hide_on_silence = true;
    format-icons = [
      "▁"
      "▂"
      "▃"
      "▄"
      "▅"
      "▆"
      "▇"
      "█"
    ];
  };

  clock = {
    tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
    format = " {:%I:%M %p} ";
    calendar = {
      mode = "year";
      mode-mon-col = 3;
      weeks-pos = "right";
      on-scroll = 1;
      format = {
        months = "<span><b>{}</b></span>";
        days = "<span><b>{}</b></span>";
        weeks = "<span><b>W{}</b></span>";
        weekdays = "<span><b>{}</b></span>";
        today = "<span color='#ff5555'><b><u>{}</u></b></span>";
      };
    };
    actions = {
      on-click-right = "mode";
      on-click-forward = "tz_up";
      on-click-backward = "tz_down";
      on-scroll-up = "shift_up";
      on-scroll-down = "shift_down";
    };
  };

  cpu = {
    format = " {usage}%";
    tooltip = false;
    states = {
      "50" = 50;
      "60" = 75;
      "70" = 90;
    };
  };

  memory = {
    format = "󰍛 {}%";
    tooltip = false;
  };

  disk = {
    format = " {percentage_used}%";
  };

  gamemode = {
    format = "󰊴";
    format-alt = "{glyph}";
    glyph = "󰊴";
    hide-not-running = true;
    use-icon = true;
    icon-name = "input-gaming-symbolic";
    icon-spacing = 4;
    icon-size = 20;
    tooltip = true;
    tooltip-format = "Games running: {count}";
  };

  idle_inhibitor = {
    format = "{icon} ";
    format-icons = {
      activated = "";
      deactivated = "";
    };
  };

  keyboard-state = {
    numlock = true;
    capslock = true;
    format = "{icon} {name}";
    format-icons = {
      locked = "";
      unlocked = "";
    };
  };

  mpris = {
    format = "{player_icon} {status_icon} {dynamic}";
    format-paused = "{player_icon} {status_icon} <i>{dynamic}</i>";
    max-length = 45;
    player-icons = {
      chromium = "";
      default = "";
      firefox = "";
      mopidy = "";
      mpv = "";
      spotify = "";
    };
    status-icons = {
      paused = "";
      playing = "";
      stopped = "";
    };
  };

  mpd = {
    format = "{stateIcon} {consumeIcon}{randomIcon}{repeatIcon}{singleIcon}{artist} - {album} - {title} ({elapsedTime:%M:%S}/{totalTime:%M:%S}) ⸨{songPosition}|{queueLength}⸩ {volume}% ";
    format-disconnected = "Disconnected ";
    format-stopped = "{consumeIcon}{randomIcon}{repeatIcon}{singleIcon}Stopped ";
    unknown-tag = "N/A";
    interval = 2;
    consume-icons = {
      on = " ";
    };
    random-icons = {
      off = "<span color=\"#f53c3c\"></span> ";
      on = " ";
    };
    repeat-icons = {
      on = " ";
    };
    single-icons = {
      on = "1 ";
    };
    state-icons = {
      paused = "";
      playing = "";
    };
    tooltip-format = "MPD (connected)";
    tooltip-format-disconnected = "MPD (disconnected)";
  };

  network =
    let
      nm-editor = "${getExe' pkgs.networkmanagerapplet "nm-connection-editor"}";
    in
    {
      interval = 60;
      format-wifi = "󰜮 {ifname}";
      format-ethernet = "󰜮 {ifname}";
      tooltip-format = "󰈀 {ifname} via {ipaddr}/{cidr}";
      format-linked = "󰈁 {ifname} (No IP)";
      format-disconnected = " Disconnected";
      on-click = "${nm-editor}";
    };

  pulseaudio = {
    format = "{icon}";
    format-bluetooth = "{volume}% {icon}";
    format-muted = "";
    format-icons = {
      headphone = "";
      hands-free = "";
      headset = "";
      phone = "";
      portable = "";
      car = "";
      default = [
        ""
        ""
      ];
    };
    scroll-step = 1;
    on-click = "pavucontrol";
    ignored-sinks = [ "Easy Effects Sink" ];
  };

  "pulseaudio/slider" = {
    min = 0;
    max = 100;
    orientation = "horizontal";
  };

  systemd-failed-units = {
    hide-on-ok = false;
    format = "✗ {nr_failed}";
    format-ok = "✓";
    system = true;
    user = false;
  };

  temperature = {
    hwmon-path-abs = "/sys/devices/pci0000:00/0000:00:18.3/hwmon";
    input-filename = "temp3_input";
    critical-threshold = 80;
    format-critical = "{temperatureC}°C {icon}";
    format = "{icon} {temperatureC}°C";
    format-icons = [
      ""
      ""
      ""
    ];
    interval = "5";
    tooltip = false;
  };

  tray = {
    spacing = 10;
  };

  user = {
    format = "{user}";
    interval = 60;
    height = 30;
    width = 30;
    icon = true;
  };

  wireplumber = {
    format = "{icon}";
    format-muted = "";
    on-click = "${getExe' pkgs.coreutils "sleep"} 0.1 && ${getExe pkgs.helvum}";
    format-icons = [
      ""
      ""
      ""
    ];
  };
}

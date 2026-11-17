{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  swayosdStyle = pkgs.writeText "swayosd.css" ''
    @import url("file://${pkgs.swayosd}/etc/xdg/swayosd/style.css");

    window#osd {
      background: shade(@theme_bg_color, 1.15);
    }
  '';

  swayosd-client = lib.getExe' pkgs.swayosd "swayosd-client";

  stevia = pkgs.stevia.overrideAttrs (old: {
    version = "quad-mobile-${inputs.stevia-mobile.shortRev}";
    src = inputs.stevia-mobile;
    # Needed by newer Stevia than nixpkgs has
    buildInputs = old.buildInputs ++ [
      pkgs.gsettings-desktop-schemas
      pkgs.gst_all_1.gstreamer
      pkgs.gst_all_1.gst-plugins-base
      pkgs.libsoup_3
    ];
    mesonFlags = old.mesonFlags ++ [
      "-Duim=disabled"
      "-Dgovarnam=disabled"
    ];
  });

  hypridleConfig = pkgs.writeText "hypridle.conf" ''
    general {
      lock_cmd = ${config.quad.lock}
      before_sleep_cmd = loginctl lock-session
    }
  '';

  suspend = pkgs.writeShellScript "suspend" ''
    ${lib.getExe pkgs.niri} msg action power-off-monitors
    exec ${config.systemd.package}/bin/systemctl suspend
  '';

  swaync = pkgs.swaynotificationcenter;

  swayncStyle = pkgs.writeText "swaync.css" ''
    @import url("file://${swaync}/etc/xdg/swaync/style.css");

    :root {
      --noti-bg-focus: transparent;
      --noti-border-color: transparent;
      --notification-shadow: none;
      --border-radius: 16px;
      --notification-icon-size: 48px;
      --font-size-summary: 14px;
      --font-size-body: 14px;
    }

    .notification-row .notification-background .notification {
      background: shade(@theme_bg_color, 1.25);
    }

    .notification-row .notification-background .notification .notification-default-action .notification-content {
      padding: 6px;
    }

    .notification-row .notification-background .notification .notification-default-action .notification-content .text-box .body {
      opacity: 0.8;
    }
  '';

  swayncConfig = (pkgs.formats.json { }).generate "swaync.json" (
    lib.importJSON "${swaync}/etc/xdg/swaync/config.json"
    // {
      positionX = "center";
      positionY = "top";
      notification-window-width = 344;
      ignore-gtk-theme = false;
    }
  );
in
{
  nixpkgs.overlays = [
    inputs.niri-mobile.overlays.default
    inputs.app-grid.overlays.default
  ];

  programs.niri.enable = true;

  environment.etc."niri/config.kdl".text = ''
    output "DSI-1" {
        scale 3
    }

    input {
        touch { edge-swipe-size 24; }
        // The power key is bound below instead.
        disable-power-key-handling
    }

    layout {
        gaps 16
        struts {
            left -16
            right -16
            top -16
            bottom -16
        }
        center-focused-column "always"
        default-column-width { proportion 1.0; }
        background-color "transparent"
        focus-ring { off; }
    }

    // zoom and workspace-anchor have to match the constants in the app grid.
    overview {
        zoom 0.25
        workspace-anchor 0.15
        hide-inactive-workspaces
        swipe-to-close
        swipe-down-to-exit
        open-when-empty
        workspace-shadow { off; }
    }

    gestures {
        workspace-switch { off; }
    }

    window-rule {
        open-floating false
    }

    layer-rule {
        match namespace="^app-grid$"
        place-within-backdrop true
        backdrop-input true
    }

    layer-rule {
        match namespace="^wallpaper$"
        place-within-backdrop true
    }

    prefer-no-csd

    hotkey-overlay {
        skip-at-startup
    }

    spawn-at-startup "${lib.getExe pkgs.swaybg}" "-i" "${../../background.jpg}" "-m" "fill"
    spawn-at-startup "${lib.getExe pkgs.app-grid}"
    spawn-at-startup "${lib.getExe stevia}"
    spawn-at-startup "${lib.getExe' pkgs.swayosd "swayosd-server"}" "--style" "${swayosdStyle}"
    spawn-at-startup "${lib.getExe' swaync "swaync"}" "--style" "${swayncStyle}" "--config" "${swayncConfig}"
    // We log in automatically, so lock straight away.
    spawn-at-startup "${config.quad.lock}"
    spawn-at-startup "${lib.getExe pkgs.hypridle}" "--config" "${hypridleConfig}"

    binds {
        XF86PowerOff allow-when-locked=true { spawn "${suspend}"; }
        XF86AudioRaiseVolume allow-when-locked=true { spawn "${swayosd-client}" "--output-volume" "raise"; }
        XF86AudioLowerVolume allow-when-locked=true { spawn "${swayosd-client}" "--output-volume" "lower"; }
    }
  '';

  quad.session = lib.getExe' pkgs.niri "niri-session";

  services.logind.settings.Login = {
    HandlePowerKey = "ignore";
    HandlePowerKeyLongPress = "poweroff";
  };

  # Let GTK use text-input-v3, so the on-screen keyboard gets the text fields.
  environment.extraInit = ''
    unset GTK_IM_MODULE QT_IM_MODULE XMODIFIERS
  '';

  users.users.quadradical.maid.gsettings.settings.org.gnome.desktop = {
    a11y.applications.screen-keyboard-enabled = true;
    wm.preferences.button-layout = "appmenu:";
  };
}

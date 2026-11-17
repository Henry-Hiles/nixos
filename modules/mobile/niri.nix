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

  lock = pkgs.writeShellScript "lock" ''
    ${lib.getExe' pkgs.procps "pidof"} gtklock || exec ${lib.getExe config.programs.gtklock.package}
  '';

  hypridleConfig = pkgs.writeText "hypridle.conf" ''
    general {
      lock_cmd = ${lock}
      before_sleep_cmd = loginctl lock-session
    }
  '';
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
    // We log in automatically, so lock straight away.
    spawn-at-startup "${lock}"
    spawn-at-startup "${lib.getExe pkgs.hypridle}" "--config" "${hypridleConfig}"

    binds {
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

  # The on-screen keyboard only shows itself with this on.
  users.users.quadradical.maid.gsettings.settings.org.gnome.desktop.a11y.applications.screen-keyboard-enabled =
    true;
}

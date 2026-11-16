{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  src = inputs.niri-mobile;

  niri = pkgs.niri.overrideAttrs (old: {
    inherit src;
    cargoDeps = pkgs.rustPlatform.importCargoLock {
      lockFile = "${src}/Cargo.lock";
      allowBuiltinFetchGit = true;
    };
    env = old.env // {
      NIRI_BUILD_COMMIT = "quad-mobile-${src.shortRev}";
    };
  });

  # Placeholder app grid, from test-shell/ in the clone.
  grid = pkgs.stdenvNoCC.mkDerivation {
    name = "niri-test-grid";
    src = "${src}/test-shell/grid.js";
    dontUnpack = true;

    nativeBuildInputs = with pkgs; [
      gobject-introspection
      makeWrapper
      wrapGAppsHook4
    ];
    buildInputs = with pkgs; [
      gjs
      gtk4
      gtk4-layer-shell
      libadwaita
    ];

    installPhase = ''
      install -Dm644 $src $out/share/niri-test-grid/grid.js
      # gtk4-layer-shell has to be loaded before libwayland-client.
      makeWrapper ${lib.getExe' pkgs.gjs "gjs"} $out/bin/niri-test-grid \
        --add-flags "-m $out/share/niri-test-grid/grid.js" \
        --set LD_PRELOAD ${pkgs.gtk4-layer-shell}/lib/libgtk4-layer-shell.so \
        --set NIRI_BIN ${lib.getExe niri}
    '';
  };

  swayosdStyle = pkgs.writeText "swayosd.css" ''
    @import url("file://${pkgs.swayosd}/etc/xdg/swayosd/style.css");

    window#osd {
      background: shade(@theme_bg_color, 1.15);
    }
  '';

  swayosd-client = lib.getExe' pkgs.swayosd "swayosd-client";

  # Stevia normally needs a phoc-only protocol to start.
  stevia = pkgs.stevia.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [ ./stevia-optional-device-state.patch ];
  });

  lock = pkgs.writeShellScript "lock" ''
    ${lib.getExe' pkgs.procps "pidof"} gtklock || exec ${lib.getExe config.programs.gtklock.package}
  '';
in
{
  programs.niri = {
    enable = true;
    package = niri;
  };

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
        }
        center-focused-column "always"
        default-column-width { proportion 1.0; }
        background-color "transparent"
    }

    // zoom and workspace-anchor have to match the constants in test-shell/grid.js.
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

    layer-rule {
        match namespace="^niri-test-grid$"
        follow-overview true
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
    spawn-at-startup "${lib.getExe grid}"
    spawn-at-startup "${lib.getExe stevia}"
    spawn-at-startup "${lib.getExe' pkgs.swayosd "swayosd-server"}" "--style" "${swayosdStyle}"
    // We log in automatically, so lock straight away.
    spawn-at-startup "${lock}"

    binds {
        XF86PowerOff { spawn "${lock}"; }
        XF86AudioRaiseVolume allow-when-locked=true { spawn "${swayosd-client}" "--output-volume" "raise"; }
        XF86AudioLowerVolume allow-when-locked=true { spawn "${swayosd-client}" "--output-volume" "lower"; }
    }
  '';

  quad.session = lib.getExe' niri "niri-session";

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

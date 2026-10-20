{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
let
  filename = "fht-compositor.toml";

  swaync = pkgs.swaynotificationcenter;
  swaync-config = (pkgs.formats.json { }).generate "swaync.json" (
    let
      default = lib.importJSON "${swaync}/etc/xdg/swaync/config.json";
    in
    default
    // lib.genAttrs (map (side: "control-center-margin-${side}") [
      "top"
      "bottom"
      "right"
    ]) (_: 8)
    // {
      notification-window-width = 420;
      ignore-gtk-theme = false;
      fit-to-screen = false;
      control-center-height = -1;
      widget-config = default.widget-config // {
        notifications = default.widget-config.notifications or { } // {
          vexpand = false;
        };
      };
    }
  );
  swaync-style = pkgs.writeText "swaync.css" ''
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

    .control-center {
      background: @theme_bg_color;
    }

    .notification-row .notification-background .notification,
    .notification-group.collapsed .notification-row .notification {
      background: shade(@theme_bg_color, 1.25);
    }

    .notification-row .notification-background .notification .notification-default-action:hover,
    .control-center .control-center-list .notification .notification-default-action:hover,
    .notification-group.collapsed:hover .notification-row:not(:only-child) .notification {
      background: shade(@theme_bg_color, 1.4);
    }

    .control-center .control-center-list-placeholder {
      margin-bottom: 24px;
    }

    .notification-row .notification-background .notification .notification-default-action .notification-content {
      padding: 6px;
    }

    .notification-row .notification-background .notification .notification-default-action .notification-content .text-box .time {
      font-size: 12px;
      font-weight: normal;
      opacity: 0.6;
    }

    .notification-row .notification-background .notification .notification-default-action .notification-content .text-box .body {
      opacity: 0.8;
    }
  '';

  osd-style = pkgs.writeText "swayosd.css" ''
    @import url("file://${pkgs.swayosd}/etc/xdg/swayosd/style.css");

    window#osd {
      background: shade(@theme_bg_color, 1.15);
    }
  '';

  session-programs = pkgs.writeShellApplication {
    name = "session-programs";
    runtimeInputs = with pkgs; [
      procps
      util-linux
    ];
    text = ''
      restart() {
        pattern=$1
        shift
        pkill -f "$pattern" || true
        for _ in $(seq 50); do
          pgrep -f "$pattern" >/dev/null || break
          sleep 0.1
        done
        setsid "$@" >/dev/null 2>&1 </dev/null &
      }

      restart '/bin/elephant$' systemd-cat -t elephant ${lib.getExe pkgs.elephant}
      restart 'walker.* --gapplication-service' walker --gapplication-service
      restart 'gaypanel-wrapped_' systemd-cat -t gaypanel gaypanel
      restart 'bin/swaybg ' ${lib.getExe pkgs.swaybg} -i ${../../../background.jpg} -m fill
      restart 'bin/swayosd-server ' ${lib.getExe' pkgs.swayosd "swayosd-server"} --style ${osd-style}
      restart 'bin/swaync ' ${lib.getExe' swaync "swaync"} --style ${swaync-style} --config ${swaync-config}
    '';
  };
in
{
  imports = [ inputs.fht-compositor.nixosModules.default ];

  environment.systemPackages = [ session-programs ];

  # Prefer the GNOME portal (e.g. Nautilus as the file picker), falling back to GTK. This replaces
  # the portal config fht-compositor ships.
  xdg.portal.config.fht-compositor = {
    default = [
      "gnome"
      "gtk"
    ];

    # GNOME's sends them to GNOME Shell, GTK's to any notification daemon
    "org.freedesktop.impl.portal.Notification" = [ "gtk" ];

    # GNOME's needs GNOME Shell, and GTK doesn't have one
    "org.freedesktop.impl.portal.ScreenCast" = [ "fht-compositor" ];
  };

  # Take keyboard focus when opened, so you can type into the search straight away
  environment.etc."xdg/walker/config.toml".source = (pkgs.formats.toml { }).generate "walker.toml" {
    force_keyboard_focus = true;
    theme = "system";
  };

  environment.etc = {
    # Only load the providers Walker uses
    "xdg/elephant/elephant.toml".source = (pkgs.formats.toml { }).generate "elephant.toml" {
      terminal_cmd = "ptyxis -x";
      ignored_providers = [
        "1password"
        "aptpackages"
        "archlinuxpkgs"
        "bitwarden"
        "bluetooth"
        "bookmarks"
        "clipboard"
        "dnfpackages"
        "files"
        "menus"
        "niriactions"
        "nirisessions"
        "playerctl"
        "protonpass"
        "providerlist"
        "runner"
        "snippets"
        "symbols"
        "todo"
        "unicode"
        "windows"
        "wireplumber"
      ];
    };

    # Use the same search engines as LibreWolf, with its aliases as prefixes (e.g. "no nix")
    "xdg/elephant/websearch.toml".source =
      let
        inherit (config.programs.firefox.policies) SearchEngines;
      in
      (pkgs.formats.toml { }).generate "websearch.toml" {
        entries = map (
          engine:
          {
            name = engine.Name;
            url = lib.replaceStrings [ "{searchTerms}" ] [ "%TERM%" ] engine.URLTemplate;
            default = engine.Name == SearchEngines.Default;
          }
          // lib.optionalAttrs (engine ? Alias) { prefix = "${engine.Alias} "; }
        ) SearchEngines.Add;
      };
  };

  # The default theme, minus its hardcoded @define-color palette, so the GTK theme's colors show through
  environment.etc."xdg/walker/themes/system/style.css".source =
    pkgs.runCommand "walker-system-style.css" { }
      ''
        sed '/^@define-color/d' ${pkgs.walker.src}/resources/themes/default/style.css > $out
      '';

  environment.etc.${filename}.source = (pkgs.formats.toml { }).generate "config.toml" {
    autostart = [ "session-programs" ];

    general = {
      focus-follows-mouse = true;
      inner-gaps = 10;
    };

    decorations = {
      border = {
        thickness = 4;
        radius = 12;
      };
      blur.disable = true;
    };

    keybinds = {
      Alt-Tab = "focus-next-window";
      Super-q = "close-focused-window";
      Super-f = "fullscreen-focused-window";
      Super-Ctrl-q = "quit";
      Super-Ctrl-r = {
        action = "run-command";
        arg = "fht-compositor ipc action reload-config; session-programs";
      };

      # Runs when Super is tapped on its own (patched in, see lone-modifier.patch)
      Super_L = {
        action = "run-command";
        arg = "walker";
      };

      Print = {
        action = "run-command";
        arg = "${lib.getExe pkgs.grim} -g \"$(${lib.getExe pkgs.slurp})\" - | gradia";
      };

      Super-t = {
        action = "run-command";
        arg = "ptyxis --new-window";
      };
      Super-e = {
        action = "run-command";
        arg = "nautilus";
      };
      Super-c = {
        action = "run-command";
        arg = "codium";
      };
      Super-b = {
        action = "run-command";
        arg = "librewolf";
      };

      Super-Down = {
        action = "change-window-proportion";
        arg = 0.5;
      };
      Super-Up = {
        action = "change-window-proportion";
        arg = -0.5;
      };
      Super-Left = {
        action = "change-mwfact";
        arg = -0.1;
      };
      Super-Right = {
        action = "change-mwfact";
        arg = 0.1;
      };
    }
    // builtins.listToAttrs (
      builtins.genList (i: {
        name = "Super-${toString (i + 1)}";
        value = {
          action = "focus-workspace";
          arg = i;
        };
      }) 9
    )
    # Media keys, with a SwayOSD popup
    //
      lib.mapAttrs
        (_: args: {
          action = "run-command";
          arg = "${lib.getExe' pkgs.swayosd "swayosd-client"} ${args}";
          # Holding raise/lower keeps changing the volume, but holding mute shouldn't keep toggling
          repeat = !lib.hasSuffix "mute-toggle" args;
        })
        {
          XF86AudioRaiseVolume = "--output-volume raise";
          XF86AudioLowerVolume = "--output-volume lower";
          XF86AudioMute = "--output-volume mute-toggle";
          XF86AudioMicMute = "--input-volume mute-toggle";
        };

    mousebinds = {
      Super-Left = "swap-tile";
      # Works on tiled windows too (patched in, see resize-tiled-windows.patch)
      Super-Right = "resize-tile";
      Super-wheeldown = "focus-previous-workspace";
      Super-wheelup = "focus-next-workspace";
    };

    rules = [
      {
        match-app-id = [ ".*" ];
        floating = false;
      }
    ];

    # # Blur behind gaypanel's semi-transparent background
    # layer-rules = [
    #   {
    #     match-namespace = [ "^panel$" ];
    #     blur.disable = false;
    #   }
    # ];

    outputs = {
      HDMI-A-1.position.x = 0;
      DP-3.position.x = 1920;
    };

    cursor = {
      name = "GoogleDot-Blue";
      size = 24;
    };
  };

  programs.fht-compositor = {
    enable = true;
    package =
      inputs.fht-compositor.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs
        (old: {
          patches = (old.patches or [ ]) ++ [
            ./resize-tiled-windows.patch
            ./lone-modifier.patch
          ];

          nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.makeWrapper ];

          postInstall = (old.postInstall or "") + ''
            wrapProgram $out/bin/fht-compositor \
              --add-flags "-c /etc/${filename}"
          '';
        });
  };
}

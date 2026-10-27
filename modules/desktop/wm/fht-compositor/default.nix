{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.programs.fht-compositor;
  filename = "fht-compositor.toml";
  format = pkgs.formats.toml { };

  # (Re)starts the programs that run alongside the compositor. Run at login, and on Super+Ctrl+R
  # so they pick up rebuilt versions and config. Each runs as a systemd user unit named
  # session-<name>, which is stopped (waiting for it to exit, since single-instance apps would
  # otherwise hand off to the old one) and started again. Logs: journalctl --user -u session-<name>
  session-programs = pkgs.writeShellApplication {
    name = "session-programs";
    runtimeInputs = [ pkgs.dbus ];
    text = ''
      # Give the units this session's environment (display, desktop name, etc.)
      dbus-update-activation-environment --systemd --all

      ${lib.concatLines (
        lib.mapAttrsToList (name: command: ''
          systemctl --user stop session-${name} 2>/dev/null || true
          systemd-run --user --unit=session-${name} --collect --quiet -- sh -c ${lib.escapeShellArg "exec ${command}"}
        '') cfg.sessionPrograms
      )}
    '';
  };
in
{
  imports = [ inputs.fht-compositor.nixosModules.default ];

  options.programs.fht-compositor = {
    settings = lib.mkOption {
      inherit (format) type;
      default = { };
      description = "fht-compositor's config, written to /etc/${filename}.";
    };

    sessionPrograms = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      description = "Commands started at login and restarted on Super+Ctrl+R, as systemd user units named session-<name>.";
    };
  };

  config = {
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

    environment = {
      # Called by name (rather than by store path), so Super+Ctrl+R after a rebuild runs the new version
      systemPackages = [ session-programs ];
      etc.${filename}.source = format.generate "config.toml" cfg.settings;
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

      sessionPrograms.wallpaper = "${lib.getExe pkgs.swaybg} -i ${../../../../background.jpg} -m fill";

      settings = {
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
        );

        mousebinds = {
          Super-Left = "swap-tile";
          # Works on tiled windows too (patched in, see resize-tiled-windows.patch)
          Super-Right = "resize-tile";
          Super-wheeldown = "focus-previous-workspace";
          Super-wheelup = "focus-next-workspace";
        };

        input.touchpad = {
          natural-scrolling = true;
          click-method = "clickfinger";
        };

        gesturebinds = {
          focus-next-workspace = {
            fingers = 3;
            direction = "left";
            min-swipe-distance = 1;
          };

          focus-previous-workspace = {
            fingers = 3;
            direction = "right";
            min-swipe-distance = 1;
          };
        };

        rules = [
          {
            match-app-id = [ ".*" ];
            floating = false;
          }
        ];

        outputs = {
          HDMI-A-1.position.x = 0;
          DP-3.position.x = 1920;
        };

        cursor = {
          name = "GoogleDot-Blue";
          size = 24;
        };
      };
    };
  };
}

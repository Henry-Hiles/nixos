{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
let
  filename = "fht-compositor.toml";

  session-programs = lib.getExe (
    pkgs.writeShellApplication {
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
      '';
    }
  );
in
{
  imports = [ inputs.fht-compositor.nixosModules.default ];

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
    autostart = [ session-programs ];

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
        arg = "fht-compositor ipc action reload-config; ${session-programs}";
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
    );

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

{
  inputs,
  pkgs,
  ...
}:
let
  bar = pkgs.writeText "top.blp" ''
    using Gtk 4.0;
    using Adw 1;

    $GayPanel panel {
      anchor-direction: top;
      monitor: "all";

      CenterBox {
        margin-start: 4;
        margin-end: 4;
        margin-top: 4;
        margin-bottom: 4;

        [start]
        $WorkspacesWidget {
          show-labels: false;
        }

        [center]
        $ClockWidget {
          styles [
            "pill",
            "flat",
          ]

          format: "%b %d   %H:%M";
        }

        [end]
        $SystemControlsWidget {
          styles [
            "pill",
            "flat",
          ]
        }
      }
    }
  '';

  # GNOME-style workspace dots, with the active one stretched into a pill
  style = pkgs.writeText "style.css" ''
    .workspaces button {
      min-width: 8px;
      min-height: 8px;
      padding: 0;
      border-radius: 99px;
      background: alpha(var(--window-fg-color), 0.4);
      transition: min-width 0.2s ease, background 0.2s ease;
    }

    .workspaces button.selected {
      min-width: 32px;
      padding: 0;
      background: var(--window-fg-color);
    }

    .workspaces button label {
      font-size: 0;
    }
  '';
in
{
  wrappers.gaypanel = {
    basePackage =
      inputs.gaypanel.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs
        (old: {
          patches = (old.patches or [ ]) ++ [
            ./no-sound-panic.patch
          ];
        });

    prependFlags = [
      "--config"
      # Copied rather than linked, since gaypanel ignores symlinks in bars/
      "${pkgs.runCommand "gaypanel-config" { } ''
        mkdir -p $out/bars
        cp ${bar} $out/bars/top.blp
        cp ${style} $out/style.css
      ''}"
    ];
  };
}

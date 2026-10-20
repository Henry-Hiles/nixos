{
  inputs,
  pkgs,
  ...
}:
let
  bar = pkgs.writeText "top.blp" ''
    using Gtk 4.0;

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
        Box {
          spacing: 4;

          // Hides itself when nothing is playing
          $MprisWidget {
            styles [
              "pill",
              "flat",
            ]
          }

          $SystemControlsWidget {
            styles [
              "pill",
              "flat",
            ]
          }
        }
      }
    }
  '';

  style = pkgs.writeText "style.css" ''
    window.panel {
      background: alpha(var(--window-bg-color), 0.5);
    }

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
      background: var(--window-fg-color);
    }

    .workspaces button label {
      font-size: 0;
    }
  '';
in
{
  wrappers.gaypanel = {
    basePackage = inputs.gaypanel.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs {
      patches = [ ./no-sound-panic.patch ];
    };

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

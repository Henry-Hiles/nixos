{ inputs, pkgs, ... }:
let
  filename = "fht-compositor.toml";
in
{
  imports = [ inputs.fht-compositor.nixosModules.default ];
  environment = {
    systemPackages = with pkgs; [
      grim
      slurp
    ];

    etc.${filename}.source = (pkgs.formats.toml { }).generate "config.toml" {
      autostart = [ "dms run" ];

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
        Super-f = "fullscreen-focused-window";
        Super-Ctrl-q = "quit";
        Super-Ctrl-r = "reload-config";

        Print = {
          action = "run-command";
          arg = "grim -g \"$(slurp)\" - | gradia";
        };

        Super-t = {
          action = "run-command";
          arg = "ptyxis --new-window";
        };
        Super-e = {
          action = "run-command";
          arg = "nautilus";
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
        Super-wheeldown = "focus-previous-workspace";
        Super-wheelup = "focus-next-workspace";
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

  programs.fht-compositor = {
    enable = true;
    package =
      inputs.fht-compositor.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs
        (old: {
          nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.makeWrapper ];

          postInstall = (old.postInstall or "") + ''
            wrapProgram $out/bin/fht-compositor \
              --add-flags "-c /etc/${filename}"
          '';
        });
  };
}

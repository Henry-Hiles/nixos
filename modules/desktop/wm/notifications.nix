{ pkgs, lib, ... }:
let
  swaync = pkgs.swaynotificationcenter;
in
{
  programs.fht-compositor.sessionPrograms.swaync =
    "${lib.getExe' swaync "swaync"} --style ${pkgs.writeText "swaync.css" ''
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
        background: shade(@theme_bg_color, 1.1);
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
    ''} --config ${
      (pkgs.formats.json { }).generate "swaync.json" (
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
      )
    }";
}

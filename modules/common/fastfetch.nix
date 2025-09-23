{
  pkgs,
  lib,
  ...
}:
{
  environment.shellAliases.neofetch =
    let
      color = "#4E94E4";
    in
    "${lib.getExe pkgs.fastfetch} --config ${
      pkgs.writers.writeJSON "fastfetch.json" {
        logo = {
          height = 18;
          type = "chafa";
          source = ../../logo.png;
        };
        display = {
          separator = "  ";
          color.keys = color;
        };
        modules = [
          "break"

          {
            type = "custom";
            format = "{#${color}}┌─────────{#} Hardware Information {#${color}}──────────";
          }
          {
            type = "cpu";
            key = "├";
          }
          {
            type = "gpu";
            key = "├─󰍹";
          }
          {
            type = "board";
            key = "├";
          }

          {
            type = "custom";
            format = "{#${color}}├─────────{#} Software Information {#${color}}──────────";
          }
          {
            type = "os";
            key = "├";
          }
          {
            type = "kernel";
            key = "├";
          }
          {
            type = "memory";
            key = "├";
          }
          {
            type = "disk";
            key = "├";
          }
          {
            type = "de";
            key = "├";
          }
          {
            type = "terminal";
            key = "├󰆍";
          }
          {
            type = "shell";
            key = "├󰈺";
          }
          {
            type = "font";
            key = "├";
          }
          {
            type = "wmtheme";
            key = "├󰉼";
          }
          {
            type = "icons";
            key = "├";
          }
          {
            type = "cursor";
            key = "├󰇀";
          }
          {
            type = "packages";
            key = "├󰏖";
          }
          {
            type = "custom";
            format = "{#${color}}└────────────────────────────────────────";
          }

          "break"
        ];
      }
    }";
}

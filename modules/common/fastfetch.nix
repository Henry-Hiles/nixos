{
  pkgs,
  lib,
  ...
}: {
  environment.shellAliases.neofetch = "${lib.getExe pkgs.fastfetch} --config ${pkgs.writers.writeJSON "fastfetch.json" {
    logo = rec {
      height = 16;
      width = height;
    };
    display.separator = "  ";
    modules = [
      "break"

      {
        type = "custom";
        format = "{#cyan}┌─────────{#} Hardware Information {#cyan}──────────";
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
        format = "{#cyan}├─────────{#} Software Information {#cyan}──────────";
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
        format = "{#cyan}└────────────────────────────────────────";
      }

      "break"
    ];
  }}";
}

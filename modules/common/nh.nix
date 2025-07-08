{
  inputs,
  pkgs,
  lib,
  ...
}: let
  pkg = inputs.nh.packages.${pkgs.system}.default;
  exe = lib.getExe pkg;
in {
  programs.nh = {
    enable = true;
    package = pkg;
    clean.enable = true;
    flake = "/home/quadradical/.config/nixos";
  };

  environment.shellAliases = {
    clean = "${exe} clean all";
    update = "env -C ~/.config/nixos nix flake update && rebuild";
    rebuild = "${exe} os switch";
    rebuildServer = "${exe} os switch --hostname quadraticserver --target-host 192.168.0.132";
  };
}

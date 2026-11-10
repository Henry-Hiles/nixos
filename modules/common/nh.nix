{ pkgs, lib, ... }:
let
  aliases = {
    upgrade = "nh os switch --update";
    rebuild = "nh os switch";
    boot = "nh os boot";
    temp = "nh os test";
  };
in
{
  programs.nh = {
    enable = true;
    clean.enable = true;
    flake = "/home/quadradical/.config/nixos";
  };

  system.tools.nixos-rebuild.enable = false;

  environment.systemPackages = [
    (pkgs.writeShellScriptBin "server" ''
      ${lib.concatMapAttrsStringSep "\n" (
        name: cmd: ''${name}() { ${cmd} -H quadraticserver --target-host server --diff never "$@"; }''
      ) aliases}

      "$@"
    '')
  ];

  environment.shellAliases = aliases // {
    clean = "nh clean all";
  };
}

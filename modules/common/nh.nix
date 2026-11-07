{ pkgs, lib, ... }:
let
  aliases = {
    upgrade = "nh os switch --update";
    switch = "nh os switch";
    boot = "nh os boot";
  };
in
{
  programs.nh = {
    enable = true;
    clean.enable = true;
    flake = "/home/quadradical/.config/nixos";
  };

  environment.systemPackages = [
    (pkgs.writeShellScriptBin "server" ''
      ${lib.concatMapAttrsStringSep "\n" (
        name: cmd: ''${name}() { ${cmd} -H quadraticserver --target-host server "$@"; }''
      ) aliases}

      "$@"
    '')
  ];

  environment.shellAliases = aliases // {
    clean = "nh clean all";
  };
}

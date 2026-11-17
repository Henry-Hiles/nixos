{
  config,
  pkgs,
  lib,
  ...
}:
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

  environment = {
    # e.g. `server rebuild` or `phone boot`: the aliases, for another host over SSH
    systemPackages =
      lib.mapAttrsToList
        (
          command: host:
          pkgs.writeShellScriptBin command ''
            # Stop other systems from getting GC'd
            keep() {
              path=$(nix build --no-link --print-out-paths \
                "${config.programs.nh.flake}#nixosConfigurations.${host}.config.system.build.toplevel")
              sudo nix-env --profile /nix/var/nix/profiles/${host} --set "$path"
            }

            ${lib.concatMapAttrsStringSep "\n" (
              name: cmd: ''${name}() { ${cmd} -H ${host} --target-host ${command} --diff never "$@" && keep; }''
            ) aliases}

            "$@"
          ''
        )
        {
          server = "quadraticserver";
          phone = "quadphone";
        };

    shellAliases = aliases // {
      clean = "nh clean all";
    };
  };

}

{ lib, ... }:
{
  networking.resolvconf.enable = false;
  environment.etc."resolv.conf".text = lib.mkForce "nameserver 127.0.0.1";
}

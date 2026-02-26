{ lib, ... }:
{
  services.dnsproxy = {
    enable = true;
    flags = [ "--cache" ];
    settings = rec {
      upstream = [ "https://base.dns.mullvad.net/dns-query" ];
      listen-addrs = [ "127.0.0.1" ];
      fallback = [ "1.1.1.1" ];
      bootstrap = fallback;
    };
  };

  environment.etc."resolv.conf".text = lib.mkForce "nameserver 127.0.0.1";
}

{
  services.dnsproxy = {
    enable = true;
    settings = rec {
      upstream = ["https://base.dns.mullvad.net/dns-query"];
      listen-addrs = ["127.0.0.1"];
      fallback = ["1.1.1.1"];
      bootstrap = fallback;
    };
  };

  environment.etc."resolv.conf".text = "nameserver 127.0.0.1";
}

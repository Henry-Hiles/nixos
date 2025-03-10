{
  services.dnsproxy = {
    enable = true;
    settings = rec {
      upstream = ["https://base.dns.mullvad.net/dns-query"];
      fallback = ["1.1.1.1"];
      bootstrap = fallback;
    };
  };

  environment.etc."resolv.conf".text = "nameserver 0.0.0.0";
}

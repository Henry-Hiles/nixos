{
  services.dnsproxy = {
    enable = true;
    settings = {
      upstream = ["https://base.dns.mullvad.net/dns-query"];
      bootstrap = ["1.1.1.1"];
    };
  };

  environment.etc."resolv.conf".text = "nameserver 0.0.0.0";
}

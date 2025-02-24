{
  services.dnsproxy = {
    enable = true;
    settings.upstream = ["https://base.dns.mullvad.net/dns-query"];
  };

  environment.etc."resolv.conf".text = ''
    nameserver 0.0.0.0
    nameserver 1.1.1.1 # Backup Nameserver
  '';
}

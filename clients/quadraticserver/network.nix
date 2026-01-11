{
  networking.useDHCP = false;
  systemd.network.enable = true;
  systemd.network.networks."30-wan" = {
    matchConfig.Name = "enp1s0";
    networkConfig.DHCP = "no";
    address = [
      "91.99.155.129/32"
      "2a01:4f8:c012:d202::1/64"
    ];
    routes = [
      {
        Gateway = "172.31.1.1";
        GatewayOnLink = true;
      }
      { Gateway = "fe80::1"; }
    ];
  };
}

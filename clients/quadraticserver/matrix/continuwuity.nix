{ lib, pkgs, ... }: {
  systemd.services.continuwuity.serviceConfig = {
    MemoryMax = "5.5G";
    MemorySwapMax = "4.5G";
    TimeoutStartSec = "10m";
    Restart = lib.mkForce "always";
    ExecStartPost = "/bin/sh -c 'until ${lib.getExe pkgs.curl} -s -f https://matrix.federated.nexus/.well-known/matrix/client; do sleep 1; done'";
  };

  quad.matrix = rec {
    enable = true;
    domain = "federated.nexus";
    settings = {
      cache_capacity_modifier = 1.5;
      db_cache_capacity_mb = 4096;

      admins_list = [
        "@nexusbot:federated.nexus"
        "@quadradical:federated.nexus"
        "@hexaheximal:federated.nexus"
        "@nex:nexy7574.co.uk"
      ];

      well_known = {
        support_email = "henry@henryhiles.com";
        support_mxid = "@quadradical:${domain}";
      };
    };
  };
}

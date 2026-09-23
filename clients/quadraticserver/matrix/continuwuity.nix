{ lib, pkgs, ... }: {
  systemd.services.continuwuity = {
    unitConfig.RequiresMountsFor = [ "/var/lib/private/continuwuity/media" ];
    serviceConfig = {
      MemoryMax = "5.5G";
      MemorySwapMax = "4.5G";
      TimeoutStartSec = "10m";
      Restart = lib.mkForce "always";
      ExecStartPost = "/bin/sh -c 'until ${lib.getExe pkgs.curl} -s -f https://matrix.federated.nexus/.well-known/matrix/client; do sleep 1; done'";
    };
  };

  quad.matrix = rec {
    enable = true;
    domain = "federated.nexus";
    settings = {
      cache_capacity_modifier = 1.5;
      db_cache_capacity_mb = 4096;
      allow_sticky_events = true;

      admins_list = [
        "@nexusbot:federated.nexus"
        "@quadradical:federated.nexus"
        "@hexaheximal:federated.nexus"
      ];

      well_known = {
        support_email = "henry@henryhiles.com";
        support_mxid = "@quadradical:${domain}";
      };
    };
  };

  system.fsPackages = [
    pkgs.sshfs
  ];

  systemd.mounts = [
    {
      what = "u675579@u675579.your-storagebox.de:/media";
      where = "/var/lib/private/continuwuity/media";
      type = "fuse.sshfs";
      options = builtins.concatStringsSep "," [
        "_netdev"
        "ServerAliveInterval=15"
        "ServerAliveCountMax=3"
        "IdentityFile=/home/quadradical/.ssh/id_ed25519"
        "allow_other"
      ];
    }
  ];
}

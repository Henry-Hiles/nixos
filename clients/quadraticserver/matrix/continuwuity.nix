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
      admins_list = [
        "@nexusbot:federated.nexus"
        "@quadradical:federated.nexus"
        "@hexaheximal:federated.nexus"
        "@nex:nexy7574.co.uk"
        "@nex:starstruck.systems"
      ];

      log = ''info,[transaction{origin="matrix.org"}]=debug,[transaction{origin="zirco.dev"}]=debug,[transaction{origin="starstruck.systems"}]=debug'';

      well_known = {
        support_email = "henry@henryhiles.com";
        support_mxid = "@quadradical:${domain}";
      };
    };
  };

  system.fsPackages = [
    pkgs.sshfs
  ];

  systemd.services.storagebox-online = {
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      TimeoutStartSec = "5min";
    };
    script = ''
      until ${pkgs.openssh}/bin/sftp -b /dev/null \
        -o BatchMode=yes -o ConnectTimeout=5 \
        -i /home/quadradical/.ssh/id_ed25519 \
        u675579@u675579.your-storagebox.de; do
        echo "storage box not reachable yet, retrying in 5s"
        sleep 5
      done
    '';
  };

  systemd.mounts = [
    {
      requires = [ "storagebox-online.service" ];
      after = [ "storagebox-online.service" ];
      what = "u675579@u675579.your-storagebox.de:/media";
      where = "/var/lib/private/continuwuity/media";
      type = "fuse.sshfs";
      options = builtins.concatStringsSep "," [
        "_netdev"
        "reconnect"
        "ServerAliveInterval=15"
        "ServerAliveCountMax=3"
        "IdentityFile=/home/quadradical/.ssh/id_ed25519"
        "allow_other"
      ];
    }
  ];
}

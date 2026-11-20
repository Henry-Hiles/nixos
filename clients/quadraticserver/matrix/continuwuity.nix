{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
let
  client = "matrix";
in
{
  systemd.services.continuwuity = {
    unitConfig.RequiresMountsFor = [ "/var/lib/private/continuwuity/media" ];
    # It fetches Kanidm's OIDC metadata once at startup, and logins fail until a restart if that fails
    requires = [ "kanidm-oauth2-secrets.service" ];
    wants = [ "kanidm.service" ];
    after = [
      "kanidm-oauth2-secrets.service"
      "kanidm.service"
      "caddy.service"
    ];
    serviceConfig = {
      MemoryMax = "5.5G";
      MemorySwapMax = "4.5G";
      TimeoutStartSec = "10m";
      Restart = lib.mkForce "always";
      ExecStartPost = "/bin/sh -c 'until ${lib.getExe pkgs.curl} -s -f https://matrix.federated.nexus/.well-known/matrix/client; do sleep 1; done'";
      LoadCredential = [
        "oidc-secret:${config.services.kanidm.provision.systems.oauth2.${client}.basicSecretFile}"
      ];
    };
  };

  services.kanidm.provision.systems.oauth2.${client} = {
    displayName = "Matrix";
    originUrl = "${config.services.matrix-continuwuity.settings.global.well_known.client}/_continuwuity/oidc/complete";
    originLanding = "https://app.${config.quad.matrix.domain}";
    imageFile = "${
      inputs.sable.packages.${pkgs.stdenv.hostPlatform.system}.default
    }/public/svg/logo.svg";
    basicSecretFile = "/var/lib/kanidm-oauth2-secrets/${client}";
    # The username claim is the Matrix localpart
    preferShortUsername = true;
    scopeMaps.idm_all_persons = [
      "openid"
      "email"
      "profile"
    ];
  };

  quad.matrix = rec {
    enable = true;
    domain = "federated.nexus";
    settings = {
      auto_join_rooms = [ "#space:${domain}" ];

      # Logins go through Kanidm only. Existing accounts are linked by username
      # on first login, and new ones are created then
      oauth.oidc = {
        discovery_url = "${config.services.kanidm.server.settings.origin}/oauth2/openid/${client}";
        client_id = client;
        client_secret_file = "/run/credentials/continuwuity.service/oidc-secret";
        provider_name = "Federated Nexus";
        prompt_for_localpart = false;
        additional_scopes = [
          "email"
          "profile"
        ];
      };

      admins_list = [
        "@nexusbot:federated.nexus"
        "@quadradical:federated.nexus"
        "@hexaheximal:federated.nexus"
        "@nex:nexy7574.co.uk"
        "@nex:starstruck.systems"
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

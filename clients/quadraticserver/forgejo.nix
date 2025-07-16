{
  pkgs,
  config,
  ...
}: {
  networking.firewall.allowedTCPPorts = [22];
  services = let
    domain = "git.federated.nexus";
    socket = "/run/forgejo/socket";
  in {
    forgejo = {
      enable = true;
      package = pkgs.forgejo; # Not LTS
      settings = {
        service = {
          ENABLE_INTERNAL_SIGNIN = false;
          ALLOW_ONLY_EXTERNAL_REGISTRATION = true;
        };
        repository.GO_GET_CLONE_URL_PROTOCOL = "ssh";
        actions.DEFAULT_ACTIONS_URL = "github";

        server = {
          DOMAIN = domain;
          ROOT_URL = "https://${domain}";
          HTTP_ADDR = socket;
          PROTOCOL = "http+unix";

          START_SSH_SERVER = true;
          BUILTIN_SSH_SERVER_USER = "git";

          LANDING_PAGE = "explore";
        };

        federation.enable = true;
      };
    };

    caddy.virtualHosts."${domain}".extraConfig = ''
      respond /robots.txt <<EOF
        User-agent: *
        Disallow: /*/*/archive/
        EOF 200
      reverse_proxy unix/${socket}
    '';
  };

  systemd.sockets.forgejo = {
    requiredBy = ["forgejo.service"];
    wantedBy = ["sockets.target"];

    listenStreams = [
      (toString config.services.forgejo.settings.server.SSH_PORT)
    ];
  };
}

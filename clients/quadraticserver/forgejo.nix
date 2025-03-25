{
  pkgs,
  config,
  ...
}: {
  services = let
    domain = "git.henryhiles.com";
    socket = "/run/forgejo/socket";
  in {
    forgejo = {
      enable = true;
      package = pkgs.forgejo; # Not LTS
      settings = {
        service.DISABLE_REGISTRATION = true;
        repository.GO_GET_CLONE_URL_PROTOCOL = "ssh";

        server = {
          DOMAIN = domain;
          ROOT_URL = "https://${domain}";
          HTTP_ADDR = socket;
          PROTOCOL = "http+unix";
          START_SSH_SERVER = true;
          SSH_LISTEN_PORT = 2222;
          BUILTIN_SSH_SERVER_USER = "git";
        };
      };
    };

    gitea-actions-runner = {
      package = pkgs.forgejo-actions-runner;
      instances.default = {
        enable = true;
        name = "monolith";
        url = "https://git.henryhiles.com";
        tokenFile = config.age.secrets."runnerToken.age".path;
        labels = [
          "native:host"
        ];
      };
    };

    caddy.virtualHosts."${domain}".extraConfig = "reverse_proxy unix/${socket}";
  };
}

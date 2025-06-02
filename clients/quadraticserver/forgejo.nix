{
  pkgs,
  config,
  ...
}: {
  services = let
    domain = "git.federated.nexus";
    socket = "/run/forgejo/socket";
  in {
    forgejo = {
      enable = true;
      package = pkgs.forgejo; # Not LTS
      settings = {
        service.DISABLE_REGISTRATION = true;
        repository.GO_GET_CLONE_URL_PROTOCOL = "ssh";
        actions.DEFAULT_ACTIONS_URL = "github";

        server = {
          DOMAIN = domain;
          ROOT_URL = "https://${domain}";
          HTTP_ADDR = socket;
          PROTOCOL = "http+unix";

          START_SSH_SERVER = true;
          SSH_LISTEN_PORT = 2222;
          BUILTIN_SSH_SERVER_USER = "git";

          LANDING_PAGE = "explore";
        };

        federation.enable = true;
      };
    };

    # gitea-actions-runner = {
    #   package = pkgs.forgejo-actions-runner;
    #   instances.default = {
    #     enable = true;
    #     name = "monolith";
    #     url = domain;
    #     tokenFile = config.age.secrets."runnerToken.age".path;
    #     labels = ["native:host"];
    #   };
    # };

    caddy.virtualHosts."${domain}".extraConfig = "reverse_proxy unix/${socket}";
  };
}

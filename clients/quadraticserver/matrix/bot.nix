{
  inputs,
  config,
  ...
}: {
  imports = [inputs.nexusbot.nixosModules.default];

  services = let
    socket = "/var/run/nexusbot/socket";
    domain = "register.federated.nexus";
    alias =
      "inf" + "o@f" + "edera" + "ted.n" + "exus";
  in {
    nexusbot = {
      enable = true;
      botPasswordFile = config.age.secrets."botPassword.age".path;
      smtpPasswordFile = config.age.secrets."smtpPassword.age".path;
      args = [
        "--socket"
        socket
        "--homeserver"
        config.services.grapevine.settings.server_discovery.client.base_url
        "--name"
        "nexusbot"
        "--adminRoom"
        "#admins:federated.nexus"
        "--successUri"
        "https://federated.nexus/success"
        "--failureUri"
        "https://federated.nexus/failure"
        "--inviteTo"
        "#community:federated.nexus"
        "--adminName"
        "grapevine"
        "--email"
        config.services.caddy.email
        "--emailAlias"
        alias
        "--mailDomain"
        "mail.henryhiles.com"
        "--mailName"
        "Federated Nexus"
      ];
      group = "caddy";
    };

    caddy.virtualHosts."${domain}".extraConfig = "reverse_proxy unix/${socket}";
  };
}

{
  inputs,
  config,
  ...
}: {
  imports = [inputs.nexusbot.nixosModules.default];

  services = let
    socket = "/var/run/nexusbot/socket";
    domain = "register.federated.nexus";
  in {
    nexusbot = {
      enable = true;
      botPasswordFile = config.age.secrets."botPassword.age".path;
      smtpPasswordFile = config.age.secrets."smtpPassword.age".path;
      args = ["--socket" socket "--homeserver" config.services.grapevine.settings.server_discovery.client.base_url "--name" "nexusbot" "--inviteTo" "#community:federated.nexus" "--adminRoom" "#admins:federated.nexus" "--successUri" "https://federated.nexus/success"];
      group = "caddy";
    };

    caddy.virtualHosts."${domain}".extraConfig = "reverse_proxy unix/${socket}";
  };
}

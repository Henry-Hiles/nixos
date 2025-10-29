{
  inputs,
  config,
  ...
}:
{
  imports = [ inputs.nexusbot.nixosModules.default ];

  services =
    let
      socket = "/var/run/nexusbot/socket";
      domain = "register.federated.nexus";
    in
    {
      nexusbot = {
        enable = true;
        botPasswordFile = config.age.secrets."botPassword.age".path;
        smtpPasswordFile = config.age.secrets."smtpPassword.age".path;
        args = [
          "--socket"
          socket
          "--homeserver"
          config.services.matrix-continuwuity.settings.global.well_known.client
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
          "conduit"
          "--email"
          config.services.caddy.email
          "--emailAlias"
          ("inf" + "o@f" + "edera" + "ted.n" + "exus")
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

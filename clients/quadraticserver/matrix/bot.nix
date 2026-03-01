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
          "--username"
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
          ("inf" + "o@f" + "edera" + "ted.n" + "exus")
          "--mailDomain"
          "email-smtp.us-east-1.amazonaws.com"
          "--mailName"
          "Federated Nexus"
          "--mailUsername"
          "AKIAREHCBHZLJADIVNOA"
          "--subject"
          "Your registration for Federated Nexus has been accepted!"
          "--plainText"
          "Your registration for Federated Nexus has been accepted! Your credentials are:
Username: @{username}
Password: @{password}

If you have any questions, check out our documentation: https://federated.nexus/services/matrix/.

If you have any issues, reply to this email."
          "--markdown"
          "# Your registration for Federated Nexus has been accepted!
## Your credentials are:
- ### Username: @{username}
- ### Password: @{password}

If you have any questions, check out [our documentation](https://federated.nexus/services/matrix/).

If you have any issues, reply to this email."
        ];
        group = "caddy";
      };

      caddy.virtualHosts."${domain}".extraConfig = "reverse_proxy unix/${socket}";
    };
}

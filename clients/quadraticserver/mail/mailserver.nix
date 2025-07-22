{
  config,
  inputs,
  ...
}: let
  domain = "federated.nexus";
  fqdn = "mail.${domain}";
  certDir = "/var/lib/caddy/.local/share/caddy/certificates/acme-v02.api.letsencrypt.org-directory/${fqdn}";
in {
  imports = [inputs.mailserver.nixosModule];
  mailserver = {
    enable = true;
    stateVersion = 3;

    inherit fqdn;
    domains = [domain];

    localDnsResolver = false;

    certificateScheme = "manual";
    certificateFile = "${certDir}/${fqdn}.crt";
    keyFile = "${certDir}/${fqdn}.key";

    oauth2 = let
      auth = "https://auth.federated.nexus";
    in {
      enable = true;
      introspection = {
        url = "${auth}/introspect";
        mode = "post";
      };
      oidc.configuration_url = "${auth}/.well-known/openid-configuration";
    };
  };

  services.dovecot2.group = config.services.caddy.group;
}

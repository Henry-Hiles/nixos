{ inputs, ... }:
{
  imports = [ inputs.cozybot.nixosModules.default ];

  services = {
    cozybot.enable = true;
    caddy.virtualHosts."cozyp.federated.nexus".extraConfig = ''
      respond /robots.txt <<EOF
        User-agent: *
        Disallow: *
        EOF 200

      defender redirect {
        ranges aliyun aws deepseek githubcopilot gcloud oci azurepubliccloud openai mistral vultr cloudflare digitalocean linode
        url https://ipv4.games/claim?name=federated.nexus
      }

      reverse_proxy unix//var/run/cozybot/socket
    '';

  };
}

{
  config,
  pkgs,
  ...
}: {
  services = {
    phpfpm.pools.roundcube.settings = {
      "listen.owner" = "caddy";
      "listen.group" = "caddy";
    };
    roundcube = {
      enable = true;
      configureNginx = false;

      package = pkgs.roundcube.overrideAttrs (oldAttrs: {
        version = "1.7-beta";

        src = pkgs.fetchurl {
          url = "https://github.com/roundcube/roundcubemail/releases/download/1.7-beta/roundcubemail-1.7-beta-complete.tar.gz";
          sha256 = "sha256-gYY+tyR1aPAo43oH3Prgwd0A7XmiFASZ7KWxXuf4vpk=";
        };

        patches = [./update.patch];

        installPhase = ''
          mkdir $out
          cp -r * $out/
          ln -sf /etc/roundcube/config.inc.php $out/config/config.inc.php
          rm -rf $out/installer
        '';
      });

      extraConfig = ''
        // General
        $config["skin_logo"] = "https://federated.nexus/images/icon.svg";
        $config["use_https"] = true;

        // OAuth
        $config["oauth_provider"] = "generic";
        $config["oauth_provider_name"] = "Federated Nexus";
        $config["oauth_login_redirect"] = true;

        $config["oauth_config_uri"] = "https://auth.federated.nexus/.well-known/openid-configuration";

        $config["oauth_client_id"] = "roundcube";
        $config["oauth_client_secret"] = "secret";

        $config["oauth_scope"] = "";
        $config["oauth_scope"] = "";
      '';
    };

    caddy.virtualHosts."mail.federated.nexus".extraConfig = ''
      root * ${config.services.roundcube.package}/public_html

      php_fastcgi unix/${config.services.phpfpm.pools.roundcube.socket}
      file_server
    '';
  };
}

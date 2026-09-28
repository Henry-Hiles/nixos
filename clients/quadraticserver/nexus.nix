{
  services.caddy.virtualHosts."nexus.federated.nexus".extraConfig = ''
    handle_path /flatpak/* {
      rewrite * /nexus{path}

      reverse_proxy https://henry-hiles.github.io {
        header_up Host {upstream_hostport}
      }

      @immutable path /objects/* /deltas/*
      header @immutable >Cache-Control "public, max-age=31536000, immutable"

      @mutable path /summary /summary.sig /refs/* /appstream/*
      header @mutable >Cache-Control "no-cache"
    }

    handle {
      redir https://git.federated.nexus/Nexus/nexus{uri} permanent
    }
  '';
}

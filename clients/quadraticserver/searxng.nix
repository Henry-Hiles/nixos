{ lib, ... }:
{
  services =
    let
      socket = "/var/run/searx/socket";
      domain = "search.federated.nexus";
    in
    {
      searx = {
        enable = true;
        settings =
          let
            enginesByCategory = {
              general = {
                duckduckgo = { };
                startpage = { };
              };

              "social media" = {
                tootfinder = { };
                "mastodon users" = { };
                "lemmy communities" = { };
                "lemmy comments" = { };
                "lemmy users" = { };
                "lemmy posts" = { };
              };

              images = {
                "duckduckgo images".disabled = false;
                "google images" = { };
              };

              map.openstreetmap = { };

              videos = {
                peertube.disabled = false;
                youtube = { };
              };

              it = {
                github = { };
                askubuntu = { };
                superuser = { };
                stackoverflow = { };
                codeberg.disabled = false;
                "gitea.com".disabled = false;
                "git.federated.nexus" = {
                  engine = "gitea";
                  base_url = "https://git.federated.nexus";
                };
              };
            };

            engines = builtins.foldl' (
              acc: category:
              acc
              // lib.mapAttrs' (name: val: {
                name = name;
                value = val // {
                  categories = [ category ];
                };
              }) enginesByCategory.${category}
            ) { } (lib.attrNames enginesByCategory);
          in
          {
            general = {
              instance_name = "Federated Nexus Search";
              contact_url = "mailto:henry@henryhiles.com";
            };

            search = {
              autocomplete = "duckduckgo";
              favicon_resolver = "google";
            };

            ui = {
              query_in_title = true;
              infinite_scroll = true;
              center_alignment = true;
            };

            server = {
              method = "GET";
              base_url = "https://${domain}";
              bind_address = "unix://${socket}";
              secret_key = "I don't use anything that requires a secret key.";
            };

            plugins = {
              "searx.plugins.oa_doi_rewrite.SXNGPlugin".active = true;
              "searx.plugins.tracker_url_remover.SXNGPlugin".active = true;
            };

            categories_as_tabs = builtins.listToAttrs (
              map (category: {
                name = category;
                value = { };
              }) (lib.attrNames enginesByCategory)
            );
            use_default_settings.engines.keep_only = lib.attrNames engines;
            engines = lib.mapAttrsToList (name: value: { inherit name; } // value) engines;
          };
      };

      caddy.authedHosts."${domain}" = "reverse_proxy unix/${socket}";
    };
  systemd.services =
    let
      commonConfig = builtins.mapAttrs (_: value: lib.mkForce value) {
        Group = "caddy";
        RuntimeDirectoryMode = "0770";
        UMask = "007";
      };
    in
    {
      searx.serviceConfig = commonConfig // {
        Restart = "always";
      };
      searx-init.serviceConfig = commonConfig;
    };
}

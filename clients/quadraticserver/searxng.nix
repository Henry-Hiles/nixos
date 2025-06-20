{
  config,
  lib,
  ...
}: {
  services = with config.services.searx.settings.server; {
    searx = {
      enable = true;
      environmentFile = config.age.secrets."searxngSecret.age".path;

      settings = {
        general = {
          instance_name = "Federated Nexus Search";
          contact_url = "mailto:henry@henryhiles.com";
          debug = true;
        };
        search = {
          autocomplete = "duckduckgo";
          favicon_resolver = "duckduckgo";
        };

        server = {
          base_url = "search.federated.nexus";

          port = 80;
          bind_address = "127.0.0.4";
        };

        engines = lib.mapAttrsToList (name: value: {inherit name;} // value) {
          "wikidata".disabled = true;
        };
      };
    };
    caddy.virtualHosts."${base_url}".extraConfig = "reverse_proxy ${bind_address}";
  };
}

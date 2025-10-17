{
  quad.matrix = rec {
    enable = true;
    domain = "federated.nexus";
    settings.well_known = {
      support_email = "henry@henryhiles.com";
      support_mxid = "@quadradical:${domain}";
    };
  };
}

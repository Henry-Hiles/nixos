{
  quad.matrix = rec {
    enable = true;
    domain = "federated.nexus";
    settings = {
      admins_list = [
        "@nexusbot:federated.nexus"
        "@quadradical:federated.nexus"
        "@hexaheximal:federated.nexus"
      ];

      well_known = {
        support_email = "henry@henryhiles.com";
        support_mxid = "@quadradical:${domain}";
      };
    };
  };
}

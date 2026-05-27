{
  services.unbound = {
    enable = true;
    settings = {
      server = {
        rrset-cache-size = "64M";
        msg-cache-size = "64M";
        discard-timeout = 4800;
      };
    };
  };
}

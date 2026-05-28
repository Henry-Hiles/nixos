{
  services.unbound = {
    enable = true;
    localControlSocketPath = "/run/unbound/control.sock";
    settings = {
      server = {
        extended-statistics = true;
        rrset-cache-size = "64M";
        msg-cache-size = "64M";
        discard-timeout = 4800;
      };
    };
  };
}

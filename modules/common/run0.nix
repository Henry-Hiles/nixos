{
  security = {
    polkit.persistentAuthentication = true;
    pam.services.systemd-run0 = {};
    run0-sudo-shim.enable = true;
  };
}

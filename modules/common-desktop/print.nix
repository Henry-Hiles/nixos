{
  services = {
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    gpm.enable = true;
    printing.enable = true;
  };
}

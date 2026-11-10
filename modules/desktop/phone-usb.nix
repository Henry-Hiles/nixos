{
  networking.networkmanager.ensureProfiles.profiles.phone-usb = {
    connection = {
      id = "Phone (USB)";
      type = "ethernet";
    };
    ethernet.mac-address = "02:00:00:00:42:02";
    ipv4 = {
      method = "manual";
      address1 = "172.16.42.2/24";
      never-default = true;
    };
    ipv6.method = "disabled";
  };
}

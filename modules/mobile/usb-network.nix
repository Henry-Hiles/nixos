{ inputs, ... }:
{
  imports = [ "${inputs.gadgetfs}/usb-gadget.nix" ];

  hardware.usb-gadget = {
    enable = true;
    gadgets.g = {
      default = true;
      product = "quadphone";
      functions.ecm.usb0 = {
        deviceAddress = "02:00:00:00:42:01";
        hostAddress = "02:00:00:00:42:02";
      };
      configs.def = {
        id = 1;
        functions = [ "ecm.usb0" ];
      };
    };
  };

  networking.networkmanager.ensureProfiles.profiles.usb-network = {
    connection = {
      id = "USB network";
      type = "ethernet";
      interface-name = "usb0";
    };
    ipv4 = {
      method = "manual";
      address1 = "172.16.42.1/24";
      never-default = true;
    };
    ipv6.method = "disabled";
  };
}

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

  systemd.network.links."10-usb-gadget" = {
    matchConfig.Type = "gadget";
    linkConfig.Name = "usb0";
  };

  networking.interfaces.usb0.ipv4.addresses = [
    {
      address = "172.16.42.1";
      prefixLength = 24;
    }
  ];
}

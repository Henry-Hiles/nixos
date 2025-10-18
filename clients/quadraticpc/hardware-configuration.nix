{
  boot = {
    kernelModules = [ "kvm-amd" ];
    initrd.availableKernelModules = [
      "nvme"
      "xhci_pci"
      "ahci"
      "usb_storage"
      "usbhid"
      "sd_mod"
    ];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/7d01741d-d58f-49d4-b3a2-4d37d953873d";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/E841-063C";
      fsType = "vfat";
    };
  };

  hardware.cpu.amd.updateMicrocode = true;
}

{
  boot = {
    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "ahci"
        "nvme"
        "usb_storage"
        "sd_mod"
      ];
      kernelModules = [ ];
    };
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/15598217-e3e1-4922-b336-8e9f62fad939";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/C6EC-B430";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };
  };

  hardware.cpu.intel.updateMicrocode = true;
}

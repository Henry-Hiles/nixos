{
  boot = {
    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "ahci"
        "nvme"
        "usb_storage"
        "usbhid"
        "sd_mod"
      ];
      kernelModules = [ ];
    };
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/f4b1301b-c329-4c3c-9f3a-5584bc22d0c1";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/3B50-5881";
      fsType = "vfat";
    };
  };

  powerManagement.cpuFreqGovernor = "powersave";
  hardware.cpu.intel.updateMicrocode = true;
}

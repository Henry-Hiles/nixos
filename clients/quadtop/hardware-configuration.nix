{
  boot = {
    initrd.availableKernelModules = [
      "nvme"
      "xhci_pci"
    ];
    kernelModules = [ "kvm-amd" ];
  };

  hardware = {
    amdgpu.initrd.enable = true;
    cpu.amd.updateMicrocode = true;
  };
}

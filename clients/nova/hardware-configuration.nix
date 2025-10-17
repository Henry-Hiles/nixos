{
  boot.kernelParams = [ "ip=dhcp" ];
  boot.initrd.availableKernelModules = [
    "virtio_pci"
    "virtio_net"
  ];
}

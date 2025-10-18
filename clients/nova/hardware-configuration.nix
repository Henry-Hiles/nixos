{ modulesPath, ... }:
{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  boot = {
    initrd.luks.devices."luks-ef228969-52cc-4238-b90f-9d97d625bba6".device =
      "/dev/disk/by-uuid/ef228969-52cc-4238-b90f-9d97d625bba6";
    kernelParams = [ "ip=dhcp" ];
    initrd.availableKernelModules = [
      "sr_mod"
      "ata_piix"
      "uhci_hcd"
      "virtio_pci"
      "virtio_net"
      "virtio_blk"
    ];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/3c343e41-ca80-413f-a48c-af513bb28f5c";
      fsType = "btrfs";
      options = [ "subvol=@" ];
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/9300-4D1C";
      fsType = "vfat";
      options = [
        "fmask=0077"
        "dmask=0077"
      ];
    };
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/c0c9de6f-9990-4346-b774-5f315b5ea115"; }
  ];
}

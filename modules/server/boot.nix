{modulesPath, ...}: {
  imports = [(modulesPath + "/installer/scan/not-detected.nix") (modulesPath + "/profiles/qemu-guest.nix")];
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    efiInstallAsRemovable = true;
  };
}

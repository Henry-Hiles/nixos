{
  # The image is built with an empty LUKS passphrase (systemd-repart can't take a
  # key file through the NixOS image builder). After flashing, set a real passphrase
  # and rotate the volume key, since the image's key is sitting in the nix store:
  #   run0 systemd-cryptenroll --password --wipe-slot=empty /dev/disk/by-partlabel/nixos
  #   run0 cryptsetup reencrypt /dev/disk/by-partlabel/nixos
  image.repart.partitions."30-root".repartConfig.Encrypt = "key-file";

  boot.initrd = {
    luks.forceLuksSupportInInitrd = true;
    availableKernelModules = [ "msm" ];
    unl0kr.enable = true;
  };
}

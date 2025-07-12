{inputs, ...}: {
  imports = ["${inputs.sdm845}/nixos/profiles/boot/kernel/sdm845-mainline"];
  hardware.graphics.enable32Bit = false;
}

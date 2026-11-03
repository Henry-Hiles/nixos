{
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  nixpkgs.overlays = [
    (_: super: {
      # Because of https://github.com/NixOS/nixpkgs/pull/378579
      # Only qemu-user is patched (binfmt uses it), so full qemu stays cached
      qemu-user =
        (super.qemu-user.override {
          hostCpuTargets = [ "aarch64-linux-user" ];
        }).overrideAttrs
          (old: {
            patches = (old.patches or [ ]) ++ [ ./qemu.patch ];
          });
    })
  ];
}

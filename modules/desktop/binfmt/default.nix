{
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  nixpkgs.overlays = [
    (_: super: {
      # Because of https://github.com/NixOS/nixpkgs/pull/378579
      qemu = super.qemu.overrideAttrs (old: {
        patches = (old.patches or [ ]) ++ [ ./qemu.patch ];
      });
    })
  ];
}

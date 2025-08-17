{
  nixpkgs.overlays = [
    (_: super: {
      ruby_3_3 = super.ruby_3_3.overrideAttrs (old: {
        NIX_RUSTFLAGS =
          (old.NIX_RUSTFLAGS or "")
          + " --target ${super.stdenv.hostPlatform.rust.rustcTargetSpec}";
      });
    })
  ];
}

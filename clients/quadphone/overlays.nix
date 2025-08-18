{lib, ...}: {
  nixpkgs.overlays = [
    (_: super: {
      ruby_3_3 = super.ruby_3_3.overrideAttrs (old: {
        NIX_RUSTFLAGS =
          (old.NIX_RUSTFLAGS or "")
          + " --target ${super.stdenv.hostPlatform.rust.rustcTargetSpec}";
      });
      iniparser = super.iniparser.overrideAttrs (old: {
        cmakeFlags = [
          (lib.cmakeBool "BUILD_TESTING" false)
        ];
      });
      gnome-user-share = super.gnome-user-share.overrideAttrs (old: {
        postPatch = lib.optionalString (super.stdenv.buildPlatform != super.stdenv.hostPlatform) ''
          substituteInPlace src/meson.build \
            --replace-fail "cargo_options += [ '--target-dir', meson.project_build_root() / 'src' ]" "cargo_options += [ '--target-dir', meson.project_build_root() / 'src', '--target=${super.stdenv.hostPlatform.rust.rustcTarget}' ]" \
            --replace-fail "'cp', 'src' / rust_target / meson.project_name(), '@OUTPUT@'," "'cp', 'src' / '${super.stdenv.hostPlatform.rust.cargoShortTarget}' / rust_target / meson.project_name(), '@OUTPUT@',"
        '';
      });
    })
  ];
}

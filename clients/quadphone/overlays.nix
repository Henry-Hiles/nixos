{
  lib,
  inputs,
  ...
}: let
  ibusPath = "i18n/input-method/default.nix";
in {
  disabledModules = [ibusPath];
  imports = [
    (import "${inputs.ibus-fix}/nixos/modules/${ibusPath}")
  ];

  nixpkgs.overlays = [
    (_: super: {
      ruby_3_3 = super.ruby_3_3.overrideAttrs (old: {
        NIX_RUSTFLAGS =
          (old.NIX_RUSTFLAGS or "")
          + " --target ${super.stdenv.hostPlatform.rust.rustcTargetSpec}";
      });

      # https://github.com/NixOS/nixpkgs/pull/434550
      iniparser = super.iniparser.overrideAttrs (old: {
        cmakeFlags = [
          (lib.cmakeBool "BUILD_TESTING" false)
        ];
      });

      # https://github.com/NixOS/nixpkgs/pull/434579
      gnome-user-share = super.gnome-user-share.overrideAttrs (old: {
        env.CARGO_BUILD_TARGET = super.stdenv.hostPlatform.rust.rustcTargetSpec;
        postPatch = ''
          substituteInPlace src/meson.build \
            --replace-fail "'cp', 'src' / rust_target / meson.project_name(), '@OUTPUT@'," "'cp', 'src' / '${super.stdenv.hostPlatform.rust.cargoShortTarget}' / rust_target / meson.project_name(), '@OUTPUT@',"
        '';
      });

      # TODO: Upstream to nixpkgs
      glycin-loaders = super.glycin-loaders.overrideAttrs (old: {
        env.CARGO_BUILD_TARGET = super.stdenv.hostPlatform.rust.rustcTargetSpec;
        postPatch = ''
          substituteInPlace loaders/meson.build \
            --replace-fail "cargo_target_dir / rust_target / loader," "cargo_target_dir / '${super.stdenv.hostPlatform.rust.cargoShortTarget}' / rust_target / loader,"
        '';

        nativeBuildInputs = (old.nativeBuildInputs or []) ++ [super.buildPackages.rustPlatform.cargoSetupHook];
        cargoVendorDir = "vendor";
      });

      # https://github.com/NixOS/nixpkgs/pull/434998
      ibus = super.ibus.overrideAttrs (old: {
        buildInputs = (old.buildInputs or []) ++ [super.wayland-scanner];
      });

      # https://github.com/NixOS/nixpkgs/pull/431159
      gst_all_1 =
        super.gst_all_1
        // {
          gst-editing-services = super.gst_all_1.gst-editing-services.overrideAttrs (old: {
            mesonFlags = [
              (lib.mesonEnable "doc" false)
              (lib.mesonEnable "tests" false)
            ];
          });
        };
    })
  ];
}

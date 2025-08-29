{
  lib,
  inputs,
  ...
}: let
  ibusPath = "i18n/input-method/default.nix";
in {
  # disabledModules = [ibusPath];
  # imports = [
  #   (import "${inputs.ibus-fix}/nixos/modules/${ibusPath}")
  # ];

  # nixpkgs.overlays = [
  #   (_: super: {
  #     # https://github.com/NixOS/nixpkgs/pull/434550
  #     iniparser = super.iniparser.overrideAttrs (old: {
  #       cmakeFlags = [
  #         (lib.cmakeBool "BUILD_TESTING" false)
  #       ];
  #     });

  #     # TODO: Upstream to nixpkgs
  #     glycin-loaders = super.glycin-loaders.overrideAttrs (old: {
  #       env.CARGO_BUILD_TARGET = super.stdenv.hostPlatform.rust.rustcTargetSpec;
  #       postPatch = ''
  #         substituteInPlace loaders/meson.build \
  #           --replace-fail "cargo_target_dir / rust_target / loader," "cargo_target_dir / '${super.stdenv.hostPlatform.rust.cargoShortTarget}' / rust_target / loader,"
  #       '';

  #       nativeBuildInputs = (old.nativeBuildInputs or []) ++ [super.buildPackages.rustPlatform.cargoSetupHook];
  #       cargoVendorDir = "vendor";
  #     });

  #     # TODO: Maybe upstream to nixpkgs (ruby maintainer please reply to my DM)
  #     ruby_3_3 = super.ruby_3_3.overrideAttrs (old: {
  #       NIX_RUSTFLAGS =
  #         (old.NIX_RUSTFLAGS or "")
  #         + " --target ${super.stdenv.hostPlatform.rust.rustcTargetSpec}";
  #     });
  #   })
  # ];
}

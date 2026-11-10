{
  inputs,
  lib,
  config,
  ...
}:
let
  cfg = config.quadphone;
  host = config.nixpkgs.hostPlatform;

  otherOverlays = lib.init config.nixpkgs.overlays;

  # cache-only due to no binfmt
  nativePkgs = import inputs.nixpkgs {
    localSystem = host;
    inherit (config.nixpkgs) config;
  };

  # Only used to detect which packages the other overlays change.
  nativeOverlaid = import inputs.nixpkgs {
    localSystem = host;
    inherit (config.nixpkgs) config;
    overlays = otherOverlays;
  };

  # The cross toolchain and bootstrapping must stay cross.
  # Interpreters too: their package sets splice the interpreter from this set.
  toolchainRegex = "(python[0-9]*(Minimal|Full)?|.*[sS]tdenv.*|glibc|libc|libcCross|gcc|libgcc|binutils.*|bintools.*|musl|linuxHeaders)";

  drvPathOf = v: (builtins.tryEval v.drvPath).value or null;
  tryGet = path: set: (builtins.tryEval (lib.attrByPath path null set)).value or null;

  useNative =
    path: native:
    let
      name = lib.concatStringsSep "." path;
    in
    !(builtins.elem name cfg.crossPackages)
    && builtins.match toolchainRegex name == null
    && lib.isDerivation native
    && lib.meta.availableOn host native
    && (native.meta.license.free or true)
    # Trivial builders (runCommand, buildEnv, ...) are never substituted
    && (native.allowSubstitutes or true) != false
    && (native.allowSubstitutes or true) != ""
    # Not modified (directly or through a dependency) by another overlay
    && drvPathOf native == drvPathOf (tryGet path nativeOverlaid);

  withCrossFunctions =
    native: cross:
    let
      wrap =
        n: arg:
        let
          r = native.${n} arg;
        in
        if lib.isDerivation r && drvPathOf r == drvPathOf native then
          withCrossFunctions r (cross.${n} arg)
        else
          cross.${n} arg;

      isBuilder = n: builtins.match builderRegex n != null && !lib.elem n customisers;
    in
    # Attr names must only depend on native, forcing cross here can recurse.
    native
    // lib.genAttrs (lib.filter (n: native ? ${n}) customisers) wrap
    // lib.genAttrs (lib.filter isBuilder (builtins.attrNames native)) (n: cross.${n});

  builderRegex = "(pkgs|.*[pP]ackages|callPackage|(mk|build|with|wrap)([A-Z].*)?)";

  customisers = [
    "override"
    "overrideAttrs"
    "overrideDerivation"
    "overridePythonAttrs"
    "overrideModAttrs"
  ];

  pick =
    path: v:
    if lib.isDerivation v then
      let
        native = tryGet path nativePkgs;
      in
      if useNative path native then withCrossFunctions native v else v
    # Package sets like kdePackages, gnomeExtensions, lixPackageSets.lix_2_96
    else if builtins.length path <= 2 && builtins.isAttrs v && (v.recurseForDerivations or false) then
      builtins.mapAttrs (name: pick (path ++ [ name ])) v
    else
      v;
in
{
  options.quadphone.crossPackages = lib.mkOption {
    type = with lib.types; listOf str;
    default = [ ];
    description = ''
      Top-level attribute names that should always be cross-compiled instead of
      substituted from the binary cache (i.e. ones that turn out not to be cached).
    '';
  };

  config = {
    nixpkgs.buildPlatform = "x86_64-linux";

    # Must be the last overlay, see otherOverlays.
    nixpkgs.overlays = lib.mkOrder 10000 [
      (
        _: prev:
        lib.optionalAttrs (prev.stdenv.hostPlatform.config != prev.stdenv.buildPlatform.config) {
          stdenv = prev.overrideCC prev.stdenv (
            prev.stdenv.cc.override {
              bintools = prev.stdenv.cc.bintools.override {
                extraBuildCommands = ''
                  echo "-rpath-link ${nativePkgs.stdenv.cc.cc.lib}/lib" >> $out/nix-support/libc-ldflags
                '';
              };
            }
          );
        }
      )
      (
        _: prev:
        builtins.mapAttrs (
          name: v:
          if prev.stdenv.hostPlatform.config == prev.stdenv.buildPlatform.config then v else pick [ name ] v
        ) prev
      )
    ];
  };
}

{
  config,
  inputs,
  crossPkgs,
  lib,
  ...
}: {
  imports = [
    (_:
      import
      "${inputs.sdm845}/nixos/profiles/boot/kernel/sdm845-mainline"
      {
        inherit lib config;
        pkgs = crossPkgs;
        inputs = inputs.sdm845.inputs;
      })
  ];

  boot.initrd.allowMissingModules = true;

  nixpkgs = {
    hostPlatform = "aarch64-linux";
    config.allowBroken = true;
  };
}

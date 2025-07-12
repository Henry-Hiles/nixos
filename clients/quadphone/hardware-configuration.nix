{
  config,
  inputs,
  pkgs,
  lib,
  ...
}: {
  imports = [
    (_:
      import
      "${inputs.sdm845}/nixos/profiles/boot/kernel/sdm845-mainline"
      {
        inherit pkgs lib config;
        inputs = inputs.sdm845.inputs;
      })
  ];

  nixpkgs.hostPlatform = "aarch64-linux";
  nixpkgs.config.allowBroken = true;
}

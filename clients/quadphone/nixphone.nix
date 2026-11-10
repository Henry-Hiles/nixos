{ inputs, lib, ... }:
{
  imports = [ inputs.nixphone.nixosModules.sdm845-oneplus-fajita ];

  quadphone.crossPackages = [
    "nix-direnv"
  ];

  # nixphone loads pmi8998_haptics in the initrd, but the kernel config doesn't build it
  # TODO: upstream to nixphone
  boot.kernelPatches = [
    {
      name = "pmi8998-haptics";
      patch = null;
      structuredExtraConfig.INPUT_QCOM_PMI8998_HAPTICS = lib.kernel.module;
    }
  ];

  # TODO: flutter apps don't cross compile, and the flake's package isn't cached
  programs.nexus.enable = lib.mkForce false;
}

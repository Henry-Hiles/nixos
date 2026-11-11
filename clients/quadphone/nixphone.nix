{
  inputs,
  pkgs,
  ...
}:
{
  imports = [ inputs.nixphone.nixosModules.sdm845-oneplus-fajita ];

  boot.kernelPatches = [
    {
      name = "rust-fix-rustc-option-cross";
      patch = pkgs.fetchpatch {
        name = "rust-kasan-kbuild-fix-rustc-option-when-cross-compiling.patch";
        url = "https://github.com/torvalds/linux/commit/4a44b17406cb5a93f90af3df9392b3a45eb336fb.patch";
        hash = "sha256-+mOEhCM+LDRFEk/7y1hEgpH1Ane4bdH1xmA55gaRCro=";
      };
    }
  ];
}

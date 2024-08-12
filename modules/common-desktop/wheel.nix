{pkgs, ...}: {
  boot.extraModulePackages = [
    (pkgs.linuxKernel.packages.linux_zen.hid-tmff2.overrideAttrs
      (prev: {
        src = pkgs.fetchFromGitHub {
          owner = "Henry-Hiles";
          repo = "hid-tmff2";
          rev = "5fee95681a0091e42ecd60731db7b797fcde9d81";
          hash = "sha256-KD+NG/GR/K1PkBUkhUrob5KrHDM6IHBFmcNbByBW57g=";
          fetchSubmodules = true;
        };
      }))
  ];
}

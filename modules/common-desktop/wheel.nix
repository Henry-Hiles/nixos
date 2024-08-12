{pkgs, ...}: {
  boot.extraModulePackages = [
    (pkgs.linuxKernel.packages.linux_zen.hid-tmff2.overrideAttrs
      (prev: {
        src = pkgs.fetchFromGitHub {
          owner = "Henry-Hiles";
          repo = "hid-tmff2";
          rev = "6330a91071df2ecbf725791b7194f85adb9e1078";
          hash = "sha256-/JLKIc2ZPRjbyPaXXaV4U/hQ595ZshG3RW5iX9V7U4o=";
          fetchSubmodules = true;
        };
      }))
  ];

  environment.systemPackages = [pkgs.oversteer];
}

{pkgs, ...}: {
  boot.extraModulePackages = [
    (pkgs.linuxKernel.packages.linux_zen.hid-tmff2.overrideAttrs
      (prev: {
        src = pkgs.fetchFromGitHub {
          owner = "Kimplul";
          repo = "hid-tmff2";
          rev = "cc4226299569b5a1402c0b937c6b3a2e0f246af4";
          hash = "sha256-Hv6eLbf5K9qGhweKHHf7IpZaCFsLMCvC0vxBapQOSpQ=";
          fetchSubmodules = true;
        };
      }))
  ];

  environment.systemPackages = with pkgs; [oversteer linuxConsoleTools];
  services.udev.packages = [pkgs.oversteer];
}

{pkgs, ...}: {
  hardware.keyboard.qmk.enable = true;
  environment.systemPackages = [pkgs.qmk];
}

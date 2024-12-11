{pkgs, ...}: {
  # boot.extraModulePackages = [pkgs.linuxKernel.packages.linux_zen.hid-tmff2];

  environment.systemPackages = with pkgs; [oversteer linuxConsoleTools];
  # services.udev.packages = [pkgs.oversteer];
}

{
  pkgs,
  config,
  ...
}: {
  boot.blacklistedKernelModules = ["usb-thrustmaster" "hid-thrustmaster"];
  boot.extraModulePackages = [config.boot.kernelPackages.hid-tmff2];

  environment.systemPackages = with pkgs; [oversteer linuxConsoleTools];
  services.udev.packages = [pkgs.oversteer];
}

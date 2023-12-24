{
  hardware.nvidia = {
    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };

      intelBusId = "PCI:00:02:0";
      nvidiaBusId = "PCI:01:00:0";
    };
    open = true;
    nvidiaSettings = false;
    modesetting.enable = true;
    nvidiaPersistenced = true;
    dynamicBoost.enable = true;
  };

  services.xserver.videoDrivers = ["nvidia"];
  virtualisation.libvirtd.enable = true;
  networking.hostName = "quadtop";
}

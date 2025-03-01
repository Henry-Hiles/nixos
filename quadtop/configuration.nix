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

  programs.gamemode.enable = true;
  environment.sessionVariables.GAMEMODERUNEXEC = "nvidia-offload";
  services.xserver.videoDrivers = ["nvidia"];
  networking.hostName = "quadtop";
}

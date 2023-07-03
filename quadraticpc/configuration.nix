{pkgs, ...}: {
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelParams = ["sysrq_always_enabled=1"];
  };

  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };

    nvidia = {
      modesetting.enable = true;
      nvidiaPersistenced = true;
      open = true;
      nvidiaSettings = false;
      prime = {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };

        intelBusId = "PCI:00:02:0";
        nvidiaBusId = "PCI:01:00:0";
      };
    };
  };

  networking = {
    hostName = "quadraticpc";
    networkmanager.enable = true;
  };

  services = {
    xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
      layout = "us";
      videoDrivers = ["nvidia"];
    };

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      #jack.enable = true;
    };

    printing.enable = true;
    auto-cpufreq.enable = true;
  };

  environment = {
    shellAliases = {
      neofetch = "neowofetch";
    };

    sessionVariables = {
      XDG_DATA_HOME = "$HOME/.local/share";
      EDITOR = "micro";
      VISUAL = "micro";
      NIXOS_OZONE_WL = "1";
      fish_greeting = "";
    };

    systemPackages = with pkgs; [
      heroic
      killall
      armcord
      hyfetch
      libreoffice
      gnomeExtensions.caffeine
      gnomeExtensions.pop-shell
      gnomeExtensions.appindicator
      gnomeExtensions.search-light
      gnomeExtensions.aylurs-widgets
      gnomeExtensions.just-perfection
      gnomeExtensions.burn-my-windows
      gnomeExtensions.fullscreen-avoider
      gnomeExtensions.compiz-windows-effect
    ];
  };

  programs = {
    steam = {
      enable = true;
      # package = pkgs.symlinkJoin {
      # name = pkgs.steam.name;
      # paths = [pkgs.steam];
      # buildInputs = [pkgs.makeWrapper];
      # postBuild = ''wrapProgram $out/bin/steam --add-flags "-gamepadui"'';
      # };
    };
    fish.interactiveShellInit = "neowofetch";
  };

  sound.enable = true;
  system.stateVersion = "23.05";
  hardware.pulseaudio.enable = false;
}

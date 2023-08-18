{
  pkgs,
  inputs,
  nixpkgs,
  ...
}: {
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages_zen;
    kernelParams = ["sysrq_always_enabled=1"];
  };

  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };

    nvidia = {
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
  };

  networking = {
    hostName = "quadraticpc";
    networkmanager.enable = true;
  };

  services = {
    earlyoom = {
      enable = true;
      enableNotifications = true;
    };

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
    };

    avahi = {
      enable = true;
      nssmdns = true;
      openFirewall = true;
    };

    gpm.enable = true;
    printing.enable = true;
    auto-cpufreq.enable = true;
  };

  environment = {
    shellAliases = {
      neofetch = "nvidia-offload neowofetch";
    };

    sessionVariables = {
      MANGOHUD = "1";
      XDG_DATA_HOME = "$HOME/.local/share";
      EDITOR = "micro";
      VISUAL = "micro";
      NIXOS_OZONE_WL = "1";
      fish_greeting = "";
    };

    systemPackages = with pkgs; ([
        fd
        tldr
        tuba
        gimp
        aspell
        nodejs
        killall
        armcord
        ripgrep
        hyfetch
        inkscape
        pciutils
        r2modman
        libreoffice
        mediawriter
        nodePackages.pnpm
        hunspellDicts.en_CA-large
        wineWowPackages.stagingFull
        inputs.nixpkgs-heroic.legacyPackages.x86_64-linux.heroic
      ]
      ++ (with gnomeExtensions; [
        caffeine
        pop-shell
        app-hider
        appindicator
        search-light
        aylurs-widgets
        just-perfection
        burn-my-windows
        fullscreen-avoider
        compiz-windows-effect
      ]));
  };

  programs = {
    steam.enable = true;
    wireshark = {
      enable = true;
      package = pkgs.wireshark;
    };
    fish.interactiveShellInit = "neofetch";
  };

  zramSwap = {
    enable = true;
    memoryPercent = 100;
  };

  system = {
    autoUpgrade = {
      enable = true;
      flake = "/home/quadradical/.config/nixos/flake.nix";
      operation = "boot";
    };
    stateVersion = "23.05";
  };

  sound.enable = true;
  hardware.pulseaudio.enable = false;
}

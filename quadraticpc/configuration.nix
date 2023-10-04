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
      open = false;
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

  nix.settings = {
    substituters = ["https://nix-gaming.cachix.org"];
    trusted-public-keys = ["nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="];
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
      lowLatency.enable = true;
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
      EDITOR = "micro";
      VISUAL = "micro";
      fish_greeting = "";
      NIXOS_OZONE_WL = "1";
      GAMEMODERUNEXEC = "nvidia-offload";
    };

    systemPackages = with pkgs; ([
        fd
        tldr
        tuba
        gimp
        heroic
        aspell
        nodejs
        killall
        ripgrep
        hyfetch
        inkscape
        r2modman
        pciutils
        alejandra
        grapejuice
        libreoffice
        mediawriter
        virt-manager
        wl-clipboard
        android-studio
        nodePackages.pnpm
        hunspellDicts.en_CA-large
        (pkgs.discord.override {
          withOpenASAR = true;
          withVencord = true;
        })
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
    gamemode.enable = true;
    fish.interactiveShellInit = "neofetch";
  };

  zramSwap = {
    enable = true;
    memoryPercent = 100;
  };

  system.stateVersion = "23.05";

  sound.enable = true;
  hardware.pulseaudio.enable = false;
  virtualisation.libvirtd.enable = true;
}

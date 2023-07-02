{
  pkgs,
  self,
  inputs,
  ...
}: {
  # Shared configuration
  programs = {
    command-not-found.dbPath = "/etc/programs.sqlite";
    fish.enable = true;
  };

  users = {
    defaultUserShell = pkgs.fish;

    users.quadradical = {
      isNormalUser = true;
      description = "QuadRadical";
      extraGroups = ["networkmanager" "wheel"];
    };
  };

  environment = {
    etc = {
      "programs.sqlite".source = inputs.programsdb.packages.${pkgs.system}.programs-sqlite;
      "backup".source = self;
    };
    shells = [pkgs.fish];
    shellAliases = {
      # Utility
      cat = "bat";
      rm = "rmtrash";
      free = "free -h";
      ping = "prettyping";
      shutdown = "shutdown now";

      # Git
      clone = "gh repo clone";
      create = "gh repo create";

      push = "git push";
      commit = "git add -A && git commit -am";

      # NixOS
      garbage = "sudo nix-collect-garbage -d";
      flake = "$EDITOR ~/.config/nixos/flake.nix";
      common = "$EDITOR ~/.config/nixos/common.nix";
      format = "cd ~/.config/nixos/ && nix fmt; cd -";
      stylix = "$EDITOR ~/.config/nixos/$(hostname)/stylix.nix";
      rebuild = "sudo nixos-rebuild switch --flake ~/.config/nixos/#";
      config = "$EDITOR ~/.config/nixos/$(hostname)/configuration.nix";
      home-manager = "$EDITOR ~/.config/nixos/$(hostname)/home-manager.nix";
    };

    systemPackages = with pkgs; [
      exa
      micro
      rmtrash
      prettyping
    ];
  };

  security.rtkit.enable = true;
  nixpkgs.config.allowUnfree = true;
  time.timeZone = "America/Toronto";
  i18n.defaultLocale = "en_CA.UTF-8";
  hardware.pulseaudio.enable = false;
  nix.settings.experimental-features = ["nix-command" "flakes"];
}

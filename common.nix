{
  pkgs,
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
    etc."programs.sqlite".source = inputs.programsdb.packages.${pkgs.system}.programs-sqlite;
    shells = [pkgs.fish];
    shellAliases = {
      config = "$EDITOR ~/.config/nixos/$(hostname)/configuration.nix";
      flake = "$EDITOR ~/.config/nixos/flake.nix";
      common = "$EDITOR ~/.config/nixos/common.nix";
      stylix = "$EDITOR ~/.config/nixos/$(hostname)/stylix.nix";
      home-manager = "$EDITOR ~/.config/nixos/$(hostname)/home-manager.nix";
      format = "cd ~/.config/nixos/ && nix fmt; cd -";
      rebuild = "sudo nixos-rebuild switch --flake ~/.config/nixos/#";
      garbage = "sudo nix-collect-garbage -d";
    };

    systemPackages = with pkgs; [
      micro
    ];
  };

  nixpkgs.config.allowUnfree = true;
  time.timeZone = "America/Toronto";
  i18n.defaultLocale = "en_CA.UTF-8";
  hardware.pulseaudio.enable = false;
  nix.settings.experimental-features = ["nix-command" "flakes"];
  security.rtkit.enable = true;
}

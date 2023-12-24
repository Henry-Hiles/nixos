{pkgs, ...}: {
  programs.fish = {
    enable = true;
    interactiveShellInit = "neofetch";
  };
  environment = {
    systemPackages = [pkgs.hyfetch];
    sessionVariables.fish_greeting = "";
    shells = [pkgs.fish];
    shellAliases = {
      # Utility
      cat = "bat";
      rm = "gio trash";
      free = "free -h";
      ping = "prettyping";
      neofetch = "neowofetch";
      shutdown = "shutdown now";

      # Git
      clone = "gh repo clone";
      create = "gh repo create";

      push = "git push";
      commit = "git add -A && git commit -am";

      # NixOS
      dev = "nix develop";
      garbage = "sudo nix-collect-garbage -d";
      flake = "$EDITOR ~/.config/nixos/flake.nix";
      common = "$EDITOR ~/.config/nixos/common.nix";
      format = "cd ~/.config/nixos/ && nix fmt; cd -";
      stylix = "$EDITOR ~/.config/nixos/$(hostname)/stylix.nix";
      rebuild = "sudo nixos-rebuild switch --flake ~/.config/nixos/#";
      config = "$EDITOR ~/.config/nixos/$(hostname)/configuration.nix";
      home-manager = "$EDITOR ~/.config/nixos/$(hostname)/home-manager.nix";
    };
  };
  users.defaultUserShell = pkgs.fish;
}

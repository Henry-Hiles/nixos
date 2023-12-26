{pkgs, ...}: {
  programs.fish = {
    enable = true;
    interactiveShellInit = "neofetch";
  };
  environment = {
    sessionVariables.fish_greeting = "";
    shells = [pkgs.fish];
    shellAliases = {
      # Utility
      cat = "bat";
      rm = "gio trash";
      free = "free -h";
      neofetch = "neowofetch";
      shutdown = "shutdown now";

      # Git
      clone = "gh repo clone";
      create = "gh repo create";

      push = "git push";
      commit = "git add -A && git commit -am";

      # NixOS
      dev = "nix develop";
      garbage = "sudo nix-collect-garbage -d && nix-collect-garbage -d";
      rebuild = "sudo nixos-rebuild switch --flake ~/.config/nixos/#";
    };
  };
  users.defaultUserShell = pkgs.fish;
}

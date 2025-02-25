{pkgs, ...}: {
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      direnv hook fish | source
      neofetch
    '';
  };

  environment = {
    shells = [pkgs.fish];
    shellAliases = {
      # Utility
      ls = "eza";
      cat = "bat";
      rm = "gio trash";
      free = "free -h";
      neofetch = "neowofetch";
      shutdown = "shutdown now";

      # Git
      clone = "gh repo clone";
      create = "gh repo create";

      push = "git push";
      commit = "git commit -am";

      # NixOS
      garbage = "run0 nix-collect-garbage -d && nix-collect-garbage -d";
      rebuild = "run0 nixos-rebuild switch --flake ~/.config/nixos/#";
      update = "pushd ~/.config/nixos && nix flake update && rebuild && popd";
    };
  };
  users.defaultUserShell = pkgs.fish;
}

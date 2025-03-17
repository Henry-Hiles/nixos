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
      clean = "nh clean all";
      rebuild = "nh os switch";
      update = "pushd ~/.config/nixos && nix flake update && popd && rebuild";
    };
  };
  users.defaultUserShell = pkgs.fish;
}

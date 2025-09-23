{ pkgs, ... }:
{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      direnv hook fish | source
      neofetch
    '';
  };

  environment.shells = [ pkgs.fish ];
  users.defaultUserShell = pkgs.fish;
}

{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    fd
    tldr
    killall
    ripgrep
  ];
}

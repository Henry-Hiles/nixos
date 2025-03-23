{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    fd
    glib
    tldr
    killall
    ripgrep
  ];
}

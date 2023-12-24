{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    micro
    prettyping
  ];
}

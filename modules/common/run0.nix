{pkgs, ...}: {
  # environment.systemPackages = [(pkgs.writeShellScriptBin "sudo" "run0 $@")];
  # security = {
  #   sudo.enable = false;
  #   pam.services.systemd-run0 = {};
  # };
}

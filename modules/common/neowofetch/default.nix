{pkgs, ...}: {
  environment.shellAliases.neofetch = "${pkgs.hyfetch}/bin/neowofetch --config ${./neofetch.conf}";
}

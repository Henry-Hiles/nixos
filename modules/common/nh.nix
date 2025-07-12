{
  programs.nh = {
    enable = true;
    clean.enable = true;
    flake = "/home/quadradical/.config/nixos";
  };

  environment.shellAliases = {
    clean = "nh clean all";
    update = "env -C ~/.config/nixos nix flake update && rebuild";
    rebuild = "nh os switch";
    rebuild-server = "nh os switch --hostname quadraticserver --target-host 192.168.0.132";
  };
}

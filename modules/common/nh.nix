{
  programs.nh = {
    enable = true;
    clean.enable = true;
    flake = "/home/quadradical/.config/nixos";
  };

  environment.shellAliases =
    let
      build = "nixos-rebuild switch --sudo --ask-sudo-password --flake ~/.config/nixos#";
    in
    {
      clean = "nh clean all";
      update = "env -C ~/.config/nixos nix flake update";
      upgrade = "nh os switch --update";
      rebuild = "nh os switch";
      rebuild-server = build + "quadraticserver --target-host server";
      rebuild-nova = build + "nova --target-host nova";
    };
}

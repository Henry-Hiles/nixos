{
  programs.nh = {
    enable = true;
    clean.enable = true;
    flake = "/home/quadradical/.config/nixos";
  };

  environment.shellAliases =
    let
      build = "nixos-rebuild switch --flake ~/.config/nixos#quadraticserver server --ask-sudo-password --target-host ";
    in
    {
      clean = "nh clean all";
      update = "env -C ~/.config/nixos nix flake update";
      upgrade = "nh os switch --update";
      rebuild = "nh os switch";
      rebuild-server = build + "server";
      rebuild-nova = build + "nova";
    };
}

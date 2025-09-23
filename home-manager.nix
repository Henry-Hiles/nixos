{
  inputs,
  dirUtils,
  ...
}:
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
    users.quadradical.home = {
      username = "quadradical";
      homeDirectory = "/home/quadradical";
    };
    sharedModules = [ { home.stateVersion = "23.11"; } ] ++ dirUtils.dirFiles ".nix" ./home-manager;
  };
}

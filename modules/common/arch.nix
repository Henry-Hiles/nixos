{lib, ...}: {
  nixpkgs = {
    hostPlatform = lib.mkDefault "x86_64-linux";
    buildPlatform = "x86_64-linux";
  };
}

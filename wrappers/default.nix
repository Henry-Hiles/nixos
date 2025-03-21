{
  pkgs,
  inputs,
  dirUtils,
  isDesktop,
  ...
}: {
  environment.systemPackages = with dirUtils; [
    (inputs.wrapper-manager.lib.build {
      inherit pkgs;
      modules = dirFiles ".nix" ./common ++ opt isDesktop (dirFiles ".nix" ./common-desktop);
    })
  ];
}

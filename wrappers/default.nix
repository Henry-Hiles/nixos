{
  pkgs,
  inputs,
  dirUtils,
  isDesktop,
  ...
}: {
  environment.systemPackages = [
    (inputs.wrapper-manager.lib {
      inherit pkgs;
      specialArgs = {inherit inputs;};
      modules = with dirUtils; dirFiles ".nix" ./common ++ opt isDesktop (dirFiles ".nix" ./desktop);
    })
    .config.build.toplevel
  ];
}

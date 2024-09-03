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
      modules = dirFiles ./common ++ opt false (dirFiles ./common-desktop);
    })
  ];
}

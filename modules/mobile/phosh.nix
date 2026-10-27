{ pkgs, ... }:
{
  programs = {
    feedbackd.enable = true;
    calls.enable = true;
    firefox.package = pkgs.firefox-mobile;
  };

  environment.systemPackages = with pkgs; [
    chatty
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "olm-3.2.16"
  ];

  networking.modemmanager.enable = true;

  services = {
    geoclue2 = {
      enable = true;
      whitelistedAgents = [ "sm.puri.Phosh" ];
      appConfig."sm.puri.Phosh" = {
        isAllowed = true;
        isSystem = true;
      };
    };

    xserver.desktopManager.phosh = {
      enable = true;
      group = "users";
      user = "quadradical";
    };
  };

  users.users.geoclue.extraGroups = [ "networkmanager" ];
  location.provider = "geoclue2";
}

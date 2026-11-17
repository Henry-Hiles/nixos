{ pkgs, ... }:
{
  programs = {
    feedbackd.enable = true;
    calls.enable = true;
  };

  environment.systemPackages = with pkgs; [
    chatty
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "olm-3.2.16"
  ];

  networking.modemmanager.enable = true;

  services = {
    # Write logs out often, so a crash can be found.
    journald.settings.Journal.SyncIntervalSec = "15s";
    geoclue2.enable = true;
  };
  users.users.geoclue.extraGroups = [ "networkmanager" ];
  location.provider = "geoclue2";
}

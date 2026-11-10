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

  services.geoclue2.enable = true;
  users.users.geoclue.extraGroups = [ "networkmanager" ];
  location.provider = "geoclue2";
}

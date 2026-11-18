{ pkgs, ... }:
{
  programs = {
    feedbackd.enable = true;
    calls.enable = true;
  };

  environment.systemPackages = with pkgs; [
    chatty
  ];

  # chatty always links libcmatrix, which needs olm, even if Matrix isn't used
  nixpkgs.config.permittedInsecurePackages = [
    "olm-3.2.16"
  ];

  networking.modemmanager.enable = true;

  users.users.geoclue.extraGroups = [ "networkmanager" ];
  location.provider = "geoclue2";
}

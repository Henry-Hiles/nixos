{ config, ... }:
{
  users = {
    mutableUsers = false;
    users =
      let
        password = config.age.secrets."password-${config.networking.hostName}.age".path;
      in
      {
        root.hashedPasswordFile = password;
        quadradical = {
          isNormalUser = true;
          hashedPasswordFile = password;
          description = "QuadRadical";
          extraGroups = [
            "wheel"
            "networkmanager"
          ];
        };
      };
  };
}

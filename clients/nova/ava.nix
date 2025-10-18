{ config, lib, ... }:
{
  users = {
    mutableUsers = lib.mkForce true;
    users.ava = {
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIcXzWUeVwJN7iPxMT/1lhJySY4t6Z2/fH/GHVuzQFr6 cardno:32_241_564"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINBnstd9HyyIjfXWfGymWDcRlK9nZuqgTIcueiqPUDaQ star@starforge"
      ];
      hashedPasswordFile = config.age.secrets."initialFloriPassword.age".path;
      description = "Flori Ava Star";
      extraGroups = [ "wheel" ];
    };
  };
}

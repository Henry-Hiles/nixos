{ config, ... }: {
  users.users.timedout = {
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILf4WiyLVNQeCdAB/o8WjV8yH0tw+227gbLbpzNSbVzU nex@pc.timedout.uk"
    ];
    hashedPasswordFile = config.age.secrets."timedoutPassword.age".path;
    description = "Nex";
    extraGroups = [ "wheel" ];
  };
}

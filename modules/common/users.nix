{config, ...}: {
  users = {
    mutableUsers = false;
    users = {
      root.hashedPasswordFile = config.age.secrets."password.age".path;
      quadradical = {
        isNormalUser = true;
        hashedPasswordFile = config.age.secrets."password.age".path;
        description = "QuadRadical";
        extraGroups = ["wheel"];
      };
    };
  };
}

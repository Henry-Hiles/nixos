{config, ...}: {
  services.livekit = {
    enable = true;
    keyFile = config.age.secrets."livekitKeys.age".path;
  };
}

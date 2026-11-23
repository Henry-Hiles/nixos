{ config, lib, ... }:
{
  options.quad.session = lib.mkOption {
    type = lib.types.str;
    description = "Command for the graphical session. greetd logs straight into it, and the session is expected to lock itself.";
  };

  config.services.greetd = {
    enable = true;
    restart = true;
    settings =
      let
        initial_session = {
          command = config.quad.session;
          user = "quadradical";
        };
      in
      {
        inherit initial_session;

        default_session = initial_session;
      };
  };
}

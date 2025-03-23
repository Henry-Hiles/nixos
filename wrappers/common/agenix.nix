{inputs, ...}: {
  wrappers.agenix = {
    basePackage = inputs.agenix.packages.x86_64-linux.default;
    env.RULES.value = "keys.nix";
  };
}

{ pkgs, inputs, ... }:
{
  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [ obs-pipewire-audio-capture ];
    enableVirtualCamera = true;
  };

  # TODO: remove once https://github.com/NixOS/nixpkgs/pull/575861 is merged
  boot.kernelPackages = pkgs.linuxPackages.extend (
    final: _: {
      v4l2loopback = final.callPackage inputs.v4l2loopback-package.outPath { };
    }
  );
}

{
  modulesPath,
  crossPkgs,
  pkgs,
  config,
  lib,
  ...
}: let
  efiArch = pkgs.stdenv.hostPlatform.efiArch;
in {
  imports = ["${modulesPath}/image/repart.nix"];
  boot.loader.grub.enable = false;

  systemd.repart = {
    enable = true;
    partitions."03-root".Type = "root";
  };

  boot.initrd = {
    supportedFilesystems.ext4 = true;
    systemd = {
      enable = true;
      root = "gpt-auto";
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-label/ESP";
      fsType = "vfat";
    };
  };

  image.repart = {
    name = "image";
    split = true;
    partitions = {
      "20-esp" = {
        contents = {
          "/EFI/EDK2-UEFI-SHELL/SHELL.EFI".source = "${crossPkgs.edk2-uefi-shell.overrideAttrs {env.NIX_CFLAGS_COMPILE = "-Wno-error=maybe-uninitialized";}}/shell.efi";
          "/EFI/BOOT/BOOT${lib.toUpper efiArch}.EFI".source = "${pkgs.systemd}/lib/systemd/boot/efi/systemd-boot${efiArch}.efi";
          "/EFI/Linux/${config.system.boot.loader.ukiFile}".source = "${config.system.build.uki}/${config.system.boot.loader.ukiFile}";
          "/loader/loader.conf".source = crossPkgs.writeText "loader.conf" ''
            timeout 5
            console-mode keep
          '';
          "/loader/entries/shell.conf".source = crossPkgs.writeText "shell.conf" ''
            title  EDK2 UEFI Shell
            efi    /EFI/EDK2-UEFI-SHELL/SHELL.EFI
          '';
        };
        repartConfig = {
          Type = "esp";
          Label = "ESP";
          Format = "vfat";
          SplitName = "boot";
          SizeMinBytes = "500M";
          GrowFileSystem = true;
        };
      };
      "30-root" = {
        storePaths = [config.system.build.toplevel];
        contents."/boot".source = crossPkgs.runCommand "boot" {} "mkdir $out";
        repartConfig = {
          Type = "root";
          Format = "ext4";
          Label = "nixos";
          Minimize = "guess";
          SplitName = "userdata";
          GrowFileSystem = true;
        };
      };
    };
  };
}

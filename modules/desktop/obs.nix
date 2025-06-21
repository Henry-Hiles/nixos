{pkgs, ...}: {
  programs.obs-studio = {
    enable = true;
    # TODO: For virtual camera, remove on new OBS release
    package = pkgs.obs-studio.overrideAttrs (oldAttrs: {
      src = pkgs.fetchFromGitHub {
        owner = "obsproject";
        repo = "obs-studio";
        rev = "12c6febae21f369da50f09d511b54eadc1dc1342"; # https://github.com/obsproject/obs-studio/pull/11906
        sha256 = "sha256-DIlAMCdve7wfbMV5YCd3qJnZ2xwJMmQD6LamGP7ECOA=";
        fetchSubmodules = true;
      };
      version = "31.1.0-beta1";
      patches =
        builtins.filter (
          patch:
            !(
              builtins.baseNameOf (toString patch) == "Enable-file-access-and-universal-access-for-file-URL.patch"
            )
        )
        oldAttrs.patches;
    });
    plugins = with pkgs.obs-studio-plugins; [obs-pipewire-audio-capture];
    enableVirtualCamera = true;
  };
}

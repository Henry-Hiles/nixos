{pkgs, ...}: {
  wrappers.vscodium = {
    basePackage = pkgs.vscodium;

    pathAdd = with pkgs.vscode-extensions; [
      mkhl.direnv
      eamodio.gitlens
      dart-code.flutter
      jnoortheen.nix-ide
      timonwong.shellcheck
      usernamehw.errorlens
      ritwickdey.liveserver
      dbaeumer.vscode-eslint
      esbenp.prettier-vscode
      oderwat.indent-rainbow
      astro-build.astro-vscode
      pkief.material-icon-theme
      streetsidesoftware.code-spell-checker
      arcticicestudio.nord-visual-studio-code
    ];
  };
}

{ pkgs, ... }:
# The mobile layout from postmarketOS's mobile-config-firefox, the same way nixpkgs' firefox-mobile
# adds it, but on top of the LibreWolf set up in graphical/librewolf.
let
  src = pkgs.fetchFromGitLab {
    domain = "gitlab.nura.eco";
    owner = "nura";
    repo = "mobile-config-firefox";
    rev = "5.5.1";
    hash = "sha256-kIMeVKUI8/MdCJIkBlcYYEUnN7+ciDpKuReAeKkn8VY=";
  };

  configDir = pkgs.runCommand "mobile-config-firefox" { } ''
    mkdir -p $out
    cp -r ${src}/src/modules/. $out/
    cp -r ${src}/src/themes $out/
  '';

  autoconfig = pkgs.runCommand "mobile-config-autoconfig.js" { } ''
    substitute ${src}/src/mobile-config-autoconfig.js autoconfig.js \
      --replace-fail "/usr/lib/mobile-config-firefox" "${configDir}" \
      --replace-fail 'var logFile = g_chromeDir.clone();' 'var logFile = Services.dirsvc.get("ProfD", Ci.nsIFile);'
    { echo '(function () {'; cat autoconfig.js; echo '})();'; } > $out
  '';

  # The wrapper sets up autoconfig itself
  prefs = pkgs.runCommand "mobile-config-prefs.js" { } ''
    grep -v -e general.config.filename -e general.config.obscure_value \
      -e general.config.sandbox_enabled ${src}/src/mobile-config-prefs.js > $out
  '';
in
{
  programs.firefox.autoConfigFiles = [
    autoconfig
    prefs
    # Lets graphical/librewolf/customChrome.css fix things up for the mobile layout only
    (pkgs.writeText "quad-mobile-prefs.js" ''defaultPref("quad.mobile", true);'')
  ];
}

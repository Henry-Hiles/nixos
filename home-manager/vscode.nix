{
  pkgs,
  lib,
  ...
}: {
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
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

    keybindings = [
      {
        key = "ctrl+s";
        command = "workbench.action.files.saveAll";
      }
      {
        key = "ctrl+s";
        command = "-workbench.action.files.save";
      }
    ];

    userSettings = lib.mkForce {
      "dart.debugExternalPackageLibraries" = true;
      "dart.debugSdkLibraries" = true;
      "redhat.telemetry.enabled" = false;
      "editor.guides.bracketPairs" = "active";
      "window.dialogStyle" = "custom";
      "editor.inlineSuggest.enabled" = true;
      "window.titleBarStyle" = "custom";
      "editor.fontLigatures" = true;
      "editor.formatOnSave" = true;
      "editor.defaultFormatter" = "esbenp.prettier-vscode";
      "prettier.tabWidth" = 4;
      "workbench.startupEditor" = "none";
      "gitlens.hovers.currentLine.over" = "line";
      "gitlens.statusBar.enabled" = false;
      "explorer.confirmDelete" = false;
      "workbench.sideBar.location" = "right";
      "git.enableSmartCommit" = true;
      "git.openRepositoryInParentFolders" = "never";
      "explorer.confirmDragAndDrop" = false;
      "javascript.updateImportsOnFileMove.enabled" = "always";
      "editor.insertSpaces" = false;
      "prettier.semi" = false;
      "javascript.format.semicolons" = "remove";
      "window.menuBarVisibility" = "compact";
      "git.confirmSync" = false;
      "editor.detectIndentation" = false;
      "errorLens.enabledDiagnosticLevels" = ["error"];
      "git.mergeEditor" = true;
      "terminal.integrated.shellIntegration.enabled" = false;
      "gitlens.currentLine.enabled" = false;
      "gitlens.codeLens.enabled" = false;
      "workbench.colorTheme" = "Nord";
      "workbench.iconTheme" = "material-icon-theme";
      "typescript.updateImportsOnFileMove.enabled" = "always";
      "editor.wordWrap" = "on";
      "[astro]" = {
        "editor.defaultFormatter" = "astro-build.astro-vscode";
      };
      "[yaml]" = {
        "editor.defaultFormatter" = "redhat.vscode-yaml";
      };
      "editor.minimap.enabled" = false;
      "diffEditor.ignoreTrimWhitespace" = false;
      "editor.unicodeHighlight.nonBasicASCII" = false;
      "dart.checkForSdkUpdates" = false;
      "editor.codeActionsOnSave" = {
        "source.fixAll" = "explicit";
      };
      "editor.bracketPairColorization.enabled" = true;
      "explorer.fileNesting.enabled" = true;
      "explorer.fileNesting.expand" = false;
      "window.zoomLevel" = 1;
      "[nix]" = {
        "editor.formatOnSave" = true;
        "editor.defaultFormatter" = "jnoortheen.nix-ide";
      };
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = lib.meta.getExe pkgs.nil;
      "nix.serverSettings" = {
        "nil" = {
          "formatting" = {"command" = ["alejandra"];};
        };
      };
      "indentRainbow.ignoreErrorLanguages" = ["*"];
      "dart.runPubGetOnPubspecChanges" = "never";
    };
  };
}

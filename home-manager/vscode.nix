{pkgs, ...}: {
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
      eamodio.gitlens
      usernamehw.errorlens
      timonwong.shellcheck
      ritwickdey.liveserver
      dbaeumer.vscode-eslint
      esbenp.prettier-vscode
      oderwat.indent-rainbow
      astro-build.astro-vscode
      vscode-icons-team.vscode-icons
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
    userSettings = {
      "editor.bracketPairColorization.enabled" = true;
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
      "typescript.updateImportsOnFileMove.enabled" = "always";
      "editor.wordWrap" = "on";
      "[astro]" = {
        "editor.defaultFormatter" = "astro-build.astro-vscode";
      };
      "prettier.trailingComma" = "none";
      "prettier.useTabs" = true;
      "editor.minimap.enabled" = false;
      "diffEditor.ignoreTrimWhitespace" = false;
      "editor.unicodeHighlight.nonBasicASCII" = false;
    };
  };
}

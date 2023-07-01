{pkgs, ...}: {
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = [
      pkgs.vscode-extensions.eamodio.gitlens
      pkgs.vscode-extensions.usernamehw.errorlens
      pkgs.vscode-extensions.timonwong.shellcheck
      pkgs.vscode-extensions.ritwickdey.liveserver
      pkgs.vscode-extensions.dbaeumer.vscode-eslint
      pkgs.vscode-extensions.esbenp.prettier-vscode
      pkgs.vscode-extensions.oderwat.indent-rainbow
      pkgs.vscode-extensions.astro-build.astro-vscode
      pkgs.vscode-extensions.streetsidesoftware.code-spell-checker
      pkgs.vscode-extensions.arcticicestudio.nord-visual-studio-code
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
      "editor.fontFamily" = "FiraCode Nerd Font";
      "editor.fontLigatures" = true;
      "editor.formatOnSave" = true;
      "editor.defaultFormatter" = "esbenp.prettier-vscode";
      "prettier.tabWidth" = 4;
      "workbench.startupEditor" = "none";
      "gitlens.hovers.currentLine.over" = "line";
      "gitlens.statusBar.enabled" = false;
      "explorer.confirmDelete" = false;
      "workbench.sideBar.location" = "right";
      "terminal.external.linuxExec" = "alacritty";
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
      "cSpell.language" = "en-CAen-GBen";
      "prettier.trailingComma" = "none";
      "prettier.useTabs" = true;
      "editor.minimap.enabled" = false;
      "cSpell.userWords" = [
        "distrohop"
        "dotfiles"
        "Hiles"
        "micromark"
        "qscan"
        "qweather"
        "webapps"
      ];
      "diffEditor.ignoreTrimWhitespace" = false;
    };
  };
}

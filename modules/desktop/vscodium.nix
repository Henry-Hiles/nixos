{
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    (vscode-with-extensions.override {
      vscode = vscodium;
      vscodeExtensions = with vscode-extensions;
        [
          mkhl.direnv
          eamodio.gitlens
          dart-code.flutter
          dart-code.dart-code
          jnoortheen.nix-ide
          unifiedjs.vscode-mdx
          timonwong.shellcheck
          usernamehw.errorlens
          ritwickdey.liveserver
          dbaeumer.vscode-eslint
          esbenp.prettier-vscode
          oderwat.indent-rainbow
          astro-build.astro-vscode
          tamasfe.even-better-toml
          pkief.material-icon-theme
          streetsidesoftware.code-spell-checker
          arcticicestudio.nord-visual-studio-code
        ]
        ++ vscode-utils.extensionsFromVscodeMarketplace [
          {
            name = "arb-editor";
            publisher = "google";
            version = "0.2.1";
            sha256 = "sha256-uHdQeW9ZXYg6+VnD6cb5CU10/xV5hCtxt5K+j0qb7as=";
          }
        ];
    })
  ];

  users.users.quadradical.maid.file.xdg_config = {
    "VSCodium/User/settings.json".text = builtins.toJSON {
      "arb-editor.suppressedWarnings" = ["missing_metadata_for_key"];
      "dart.debugExternalPackageLibraries" = true;
      "dart.debugSdkLibraries" = true;
      "redhat.telemetry.enabled" = false;
      "editor.guides.bracketPairs" = "active";
      "window.dialogStyle" = "custom";
      "prettier.htmlWhitespaceSensitivity" = "strict";
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
          "formatting" = {"command" = [(lib.getExe pkgs.alejandra)];};
        };
      };
      "indentRainbow.ignoreErrorLanguages" = ["*"];
      "dart.runPubGetOnPubspecChanges" = "never";
    };

    "/home/quadradical/.config/VSCodium/User/keybindings.json".source = builtins.toJSON [
      {
        key = "ctrl+s";
        command = "workbench.action.files.saveAll";
      }
      {
        key = "ctrl+s";
        command = "-workbench.action.files.save";
      }
    ];
  };
}

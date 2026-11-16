# Changelog

## 0.2.1

- Windows: running `tessera.exe` by double click shows the help and waits for Enter; dropping a token file on it
  builds into a `dist` folder next to that file.
- Windows builds link the C runtime statically, so the .exe needs no extra installs.
- `build-windows.bat` builds the .exe on a Windows machine; the release workflow can also be started by hand.

## 0.2.0

- Themes: a colour can carry `$modes` (for example `dark`). CSS gets a `prefers-color-scheme` block and a
  `data-theme` selector, Swift gets a colour that follows the system appearance, Kotlin gets a `TokensDark` object.
- Aliases follow the mode of their target, so `accent -> brand` picks up brand's dark value on its own.
- `$contrast` rules are checked in every mode that changes either colour.
- `tessera watch` rebuilds when the token file changes.
- `tessera init` writes a starter token file and never overwrites.
- Files are only rewritten when their content changes.
- `--version`, integration tests, CI and a release workflow.

## 0.1.0

- First version: JSON tokens to CSS, Swift and Kotlin, aliases, WCAG contrast check.

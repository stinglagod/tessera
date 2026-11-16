# tessera

Compiles one JSON file of design tokens into CSS variables, a SwiftUI enum and a Jetpack Compose object.
It supports light and dark colours, rebuilds when the file changes, and refuses to build if a colour pair
you care about falls below its WCAG contrast minimum.

No dependencies. Build it with a recent stable Rust.

## Quick start

```sh
cargo build --release          # binary: target/release/tessera
tessera init                   # writes tokens.json
tessera build tokens.json      # writes dist/tokens.css, dist/Tokens.swift, dist/Tokens.kt
tessera watch tokens.json      # rebuilds on every save
tessera check tokens.json      # contrast report only
```

Options for `build` and `watch`: `--out <dir>` (default `dist`), `--package <name>` for the Kotlin file
(default `design.tokens`), `--only css,swift,kotlin`.

Exit codes: 0 success, 1 a contrast pair failed, 2 any other error. Files are only rewritten when their
content changes, so build tools do not see needless modifications.

## Windows

Get `tessera.exe` from a GitHub release (the `windows-x86_64` archive), or build it yourself:
install Rust from <https://rustup.rs> and run `build-windows.bat`. The result is `target\release\tessera.exe`;
it is a single file with no installer and no extra runtime.

- Double-click it to see the help.
- Drag a `tokens.json` onto it to build `dist\tokens.css`, `Tokens.swift` and `Tokens.kt` next to that file.
- Or use it from a terminal like any other command, for example `tessera.exe watch tokens.json`.

## Token file

The format follows the W3C design-tokens draft: a token is an object with `$value`, groups are plain objects,
`$type` on a group applies to everything inside it, and `"{color.brand}"` points to another token.

| Type        | Example value                    | CSS        | Swift      | Kotlin         |
|-------------|----------------------------------|------------|------------|----------------|
| `color`     | `"#2B3BFF"`, `#RGB`, `#RRGGBBAA` | hex        | `Color`    | `Color`        |
| `dimension` | `"16px"`, `"1.5rem"`             | as written | `CGFloat`  | `.dp`          |
| number      | `700`                            | number     | `Double`   | `Int`/`Double` |
| string      | `"ease-out"`                     | as written | `String`   | `String`       |
| font list   | `["Onest", "system-ui"]`         | font stack | first name | first name     |

`rem` is converted at 16px for Swift and Kotlin. A token path becomes `--color-on-accent` in CSS and
`colorOnAccent` in Swift and Kotlin. Two tokens that map to the same identifier are an error.

## Dark mode

Give a colour a `$modes` object:

```json
"bg": { "$value": "#E7EBF1", "$modes": { "dark": "#0B0E1A" } }
```

- **CSS:** the `dark` values go into `@media (prefers-color-scheme: dark)` (skipped when the page sets
  `data-theme="light"`) and into `:root[data-theme="dark"]`, so a theme toggle works in both directions.
  Any other mode name, such as `hc`, becomes `:root[data-theme="hc"]` only.
- **Swift:** a colour with a dark value follows the system appearance on iOS and macOS.
- **Kotlin:** `Tokens` holds the light values and `TokensDark` holds the dark ones. Pick one with
  `isSystemInDarkTheme()`.
- Aliases follow their target: if `accent` points to `brand`, it picks up brand's dark value on its own.
- Modes apply to colours only. Swift and Kotlin support `dark`; other modes are written to CSS only.

## Contrast rules

```json
"$contrast": [
  { "fg": "color.fg", "bg": "color.bg", "min": 7 }
]
```

Every pair is checked with its base values, and again in each mode where either colour changes.
Semi-transparent colours are composited over the background before the ratio is computed.
`build` stops without writing anything if a pair fails.

## Not done yet

Figma import, composite tokens such as shadows and typography, and platform targets beyond CSS, Swift and Kotlin.
The Swift and Kotlin output follows the documented SwiftUI and Compose APIs but is not compiled in this
repository's tests, so try it in a real project before relying on it.

## Releases

Pushing a tag such as `v0.2.1` runs `.github/workflows/release.yml`, which tests the project, builds binaries for
Linux, macOS (Intel and Apple Silicon) and Windows, and attaches them to a GitHub release.
